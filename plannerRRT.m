classdef plannerRRT < nav.algs.internal.InternalAccess
    %PLANNERRRT Create an RRT planner for geometric planning
    %   plannerRRT creates a rapidly-exploring random tree (RRT) planner 
    %   for solving geometric planning problems. RRT is a tree-based motion
    %   planner that builds a search tree incrementally from samples 
    %   randomly drawn from a given state space. The tree will eventually 
    %   span the search space and connects the start state and the goal
    %   state. The general tree growing process is as follows:
    %
    %   RRT samples a random state, STATERAND, in the state space, then it 
    %   finds a state, STATENEAREST, that is already in the search tree and
    %   is closest to STATERAND (closest as defined in the state space). 
    %   The algorithm then expands from STATENEAREST towards STATERAND, 
    %   until a state, STATENEW, is reached. Then STATENEW is added to the 
    %   search tree. 
    %
    %   For geometric RRT, the expansion/connection between two states can  
    %   always be found analytically without violating the constrains 
    %   specified in the state space of the planner. 
    %
    %   plannerRRT(STATESPACE, STATEVAL) creates an RRT planner from a 
    %   state space object, STATESPACE, and a state validator object,
    %   STATEVAL. STATEVAL's state space must be the same as STATESPACE.
    %
    %   plannerRRT properties:
    %      StateSpace            - State space for the planner
    %      StateValidator        - State validator for the planner
    %      MaxNumTreeNodes       - Max number of tree nodes
    %      MaxIterations         - Max number of iterations  
    %      MaxConnectionDistance - Max connection distance between two states
    %      GoalReachedFcn        - Callback for determing if goal is reached
    %      GoalBias              - Probability of choosing goal state during state sampling
    %
    %   plannerRRT methods:
    %      plan    - Plan a path between two states
    %      copy    - Create deep copy of the planner object
    %
    %   Example:
    %      % Create a state space
    %      ss = stateSpaceSE2;
    %
    %      % Create a occupancyMap-based state validator using the state space just created
    %      sv = validatorOccupancyMap(ss);
    %
    %      % Update the map for state validator and set map resolution as 10 cells/meter
    %      load exampleMaps
    %      map = occupancyMap(simpleMap, 10);
    %      sv.Map = map;
    %
    %      % Set validation distance for the validator
    %      sv.ValidationDistance = 0.01;
    %
    %      % Update state space bounds to be the same as map limits
    %      ss.StateBounds = [map.XWorldLimits; map.YWorldLimits; [-pi pi]];
    %
    %      % Create the path planner and increase max connection distance
    %      planner = plannerRRT(ss, sv);
    %      planner.MaxConnectionDistance = 0.3;
    %
    %      % Set the start and goal states
    %      start = [0.5, 0.5 0];
    %      goal = [2.5, 0.2, 0];
    %
    %      % Plan a path with default settings, set rng for repetitive result
    %      rng(100, 'twister')
    %      [pthObj, solnInfo] = plan(planner, start, goal)
    %
    %      % Show the results
    %      map.show; hold on;
    %      plot(solnInfo.TreeData(:,1), solnInfo.TreeData(:,2), '.-'); % tree expansion
    %      plot(pthObj.States(:,1), pthObj.States(:,2), 'r-', 'LineWidth', 2) % draw path
    %     
    %
    %   References: 
    %   [1] S.M. Lavalle, J.J. Kuffner, "Randomized kinodynamic planning",
    %       International Journal of Robotics Research, vol. 20, no. 5,
    %       pp. 378-400, May 2001 
    %
    %   See also plannerRRTStar
    
    %   Copyright 2019 The MathWorks, Inc.

    properties (Constant, Access=protected)
        GoalReached = 1
        MaxIterationsReached = 2
        MaxNumTreeNodesReached = 3
        MotionInCollision = 4
        InProgress = 5
        GoalReachedButContinue = 6
        ExistingState = 7
        
    end    
    
    properties (SetAccess = {?nav.algs.internal.InternalAccess})
        %StateSpace State space for the planner
        StateSpace
        
        %StateValidator State validator for the planner
        StateValidator
    end
    
    properties
        
        %MaxNumTreeNodes Max number of nodes in the search tree
        %   This number does not count the root node.
        %
        %   Default: 1e4
        MaxNumTreeNodes
        
        %MaxIterations Max number of iterations 
        %   This is also the max number of calls to the "extend" routine
        %
        %   Default: 1e4
        MaxIterations

        %MaxConnectionDistance Maximum length of a motion to be added to tree
        %
        %   Default: 0.1
        MaxConnectionDistance
        
        %GoalReachedFcn Callback function that checks whether goal is reached
        %   The callback function should accept three input arguments.
        %   The first argument is the planner object. The second argument
        %   is the state to check. The third argument is the goal state.
        %   States are row vectors with length consistent with the
        %   dimension of the planner's state space. The output of the
        %   callback function should be a Boolean that indicates whether
        %   goal is reached or not.
        %
        %   The expected function signature is as follows:
        %
        %      function isReached = goalReachedFcn(PLANNER, CURRENTSTATE, GOALSTATE)
        %
        %   Default: @nav.algs.checkIfGoalIsReached
        GoalReachedFcn
        
        %GoalBias Probability of choosing goal state during state sampling
        %    This propeprty defines the probability of choosing the actual 
        %    goal state during the process of randomly selecting states
        %    from the state space. It is a real number between 0.0 and 1.0.
        %    The value should be around 0.05 and should not be too large.
        %    Using the default value is usually a good start.
        %
        %    Default: 0.05
        GoalBias
    end
    
    properties (Access = {?nav.algs.internal.InternalAccess})

        %KeepIntermediateStates
        KeepIntermediateStates
        
        %NearestNeighborMethod
        NearestNeighborMethod
        
        %MaxTime
        MaxTime
        
        %RandomSamplePool Cache for pregenerated random state samples
        RandomSamplePool
        
        %PregenerateSamples Whether to pregenerate samples
        PregenerateSamples
    end
    
    properties (Access = protected)
        TreeInternal
        CurrentGoalState
    end
    

    methods
        function obj = plannerRRT(stateSpace, stateValidator)
            %PLANNERRRT Constructor
            obj.validateConstructorInput(stateSpace, stateValidator);
            obj.StateSpace = stateSpace;
            obj.StateValidator = stateValidator;
            obj.MaxNumTreeNodes = 1e4;
            obj.MaxIterations = 1e4;
            obj.MaxConnectionDistance = 0.1;
            obj.GoalReachedFcn = @nav.algs.checkIfGoalIsReached;
            obj.GoalBias = 0.05;
        end
        
        function [pathObj, solnInfo] = plan(obj, startState, goalState)
            %plan Plan a path between two states
            %   PATH = plan(PLANNER, STARTSTATE, GOALSTATE) tries to find  
            %   a valid path between STARTSTATE and GOALSTATE. The planning
            %   is carried out based on the underlying state space and state
            %   validator of PLANNER. The output, PATH, is returned as a 
            %   navpath object.
            %
            %   [PATH, SOLNINFO] = plan(PLANNER, ...) also returns a struct,
            %   SOLNINFO, as a second output that gives additional    
            %   details regarding the planning solution.
            %   SOLNINFO has the following fields:
            %
            %   IsPathFound:  Boolean indicating whether a path is found
            %
            %      ExitFlag:  A number indicating why planner terminates
            %                 1 - 'GoalReached'
            %                 2 - 'MaxIterationsReached'
            %                 3 - 'MaxNumNodesReached'
            %
            %      NumNodes:  Number of nodes in the search tree when
            %                 planner terminates (not counting the root
            %                 node).
            %
            % NumIterations:  Number of "extend" routines executed
            %
            %      TreeData:  A collection of explored states that reflects
            %                 the status of the search tree when planner
            %                 terminates. Note that nan values are inserted
            %                 as delimiters to separate each individual
            %                 edge.
            
            cleaner = onCleanup(@()obj.cleanUp);
            
            % check whether start and goal states are valid
            if ~all(obj.StateValidator.isStateValid(startState)) || ~all(all(isfinite(startState)))
                coder.internal.error('nav:navalgs:plannerrrt:StartStateNotValid');
            end
            
            if ~all(obj.StateValidator.isStateValid(goalState)) || ~all(all(isfinite(goalState)))
                coder.internal.error('nav:navalgs:plannerrrt:GoalStateNotValid');
            end
            
            startState = nav.internal.validation.validateStateVector(startState, ...
                                                              obj.StateSpace.NumStateVariables, "plan", "startState");
            goalState = nav.internal.validation.validateStateVector(goalState, ...
                                                              obj.StateSpace.NumStateVariables, "plan", "goalState");
            
            
            obj.CurrentGoalState = goalState;
            tentativeGoalIds = [];
            
            obj.TreeInternal = nav.algs.internal.SearchTree(startState);
            switch class(obj.StateSpace)
                case 'stateSpaceSE2'
                    weights = [obj.StateSpace.WeightXY, obj.StateSpace.WeightXY, obj.StateSpace.WeightTheta];
                    topologies = [0 0 1];
                    obj.TreeInternal.configureCommonCSMetric(topologies, weights);
                    obj.StateSpace.SkipStateValidation = true;
                    obj.PregenerateSamples = true;
                case 'stateSpaceDubins'
                    obj.TreeInternal.configureDubinsMetric(obj.StateSpace.MinTurningRadius);
                    obj.StateSpace.SkipStateValidation = true;
                    obj.PregenerateSamples = true;
                case 'stateSpaceReedsShepp'
                    obj.TreeInternal.configureReedsSheppMetric(obj.StateSpace.MinTurningRadius, obj.StateSpace.ReverseCost);
                otherwise
                    ss = obj.StateSpace;
                    obj.TreeInternal.configureCustomizedMetric(@ss.distance);
            end
            
            if isa(obj.StateValidator, 'validatorOccupancyMap')
                obj.StateValidator.SkipStateValidation = true;
                obj.StateValidator.configureValidatorForFastOccupancyCheck();
            end
            
            obj.preLoopSetup();
            
            if obj.PregenerateSamples
                %populate random sample pool
                obj.RandomSamplePool = obj.StateSpace.sampleUniform(obj.MaxIterations);
            end
            
            pathFound = false;
            for k = 1:obj.MaxIterations
                if obj.PregenerateSamples
                    randState = obj.RandomSamplePool(k,:); % dispense random sample from the pool
                else
                    randState = obj.StateSpace.sampleUniform();
                end
                if rand() < obj.GoalBias
                    randState = obj.CurrentGoalState;
                end
                
                [newNodeId, statusCode] = extend(obj, randState);
                
                if statusCode == obj.GoalReached 
                    pathFound = true;
                    tentativeGoalIds = [tentativeGoalIds, newNodeId]; %#ok<AGROW>
                    break;
                end
                
                if statusCode == obj.GoalReachedButContinue
                    pathFound = true;
                    tentativeGoalIds = [tentativeGoalIds, newNodeId]; %#ok<AGROW>
                end
                
                if statusCode == obj.MaxNumTreeNodesReached
                    break;
                end
            end
            
            numIterations = k;
            treeData = obj.TreeInternal.inspect();
            numNodes = obj.TreeInternal.getNumNodes()-1;
            
            exitFlag = statusCode;            
            if statusCode >= obj.MotionInCollision
                exitFlag = obj.MaxIterationsReached;
            end
            
            if pathFound
                costBest = inf;
                idBest = -1;
                for nid = tentativeGoalIds
                    c = obj.TreeInternal.getNodeCostFromRoot(nid);
                    if c < costBest
                        idBest = nid;
                        costBest = c;
                    end
                end
                pathStates = obj.TreeInternal.tracebackToRoot(idBest);

                pathObj = navPath(obj.StateSpace, flip(pathStates')); 
            else
                pathObj = navPath(obj.StateSpace);
            end

            
            solnInfo = struct();
            solnInfo.IsPathFound = pathFound;
            solnInfo.ExitFlag = exitFlag;
            solnInfo.NumNodes = numNodes;
            solnInfo.NumIterations = numIterations;
            solnInfo.TreeData = treeData';

        end

        function objCopied = copy(obj)
            %COPY Create a deep copy of the plannerRRT object
            %   PLANNERCOPIED = COPY(PLANNER) creates a deep copy of plannerRRT
            %   object, PLANNER, and returns the new object in PLANNERCOPIED.
            
            validator = obj.StateValidator.copy;
            
            objCopied = plannerRRT(validator.StateSpace, validator);
            obj.copyProperties(objCopied);
        end
    end
    
    
    methods (Access = {?nav.algs.internal.InternalAccess})
        
        function preLoopSetup(~)
            %preLoopSetup
            
            % do nothing for plannerRRT
        end
        
        function [newNodeId, statusCode] = extend(obj, randState)
            %extend The RRT "Extend" routine
            statusCode = obj.InProgress;
            newNodeId = nan;
            idx = obj.TreeInternal.nearestNeighbor(randState);
            nnState = obj.TreeInternal.getNodeState(idx);
                
            d = obj.StateSpace.distance(randState, nnState);
            newState = randState;
            
            % steer
            if d > obj.MaxConnectionDistance
                newState = obj.StateSpace.interpolate(nnState, randState, obj.MaxConnectionDistance/d);  % L/d*(randState - nnState) + nnState;
            end

            % check motion validity
            if ~obj.StateValidator.isMotionValid(nnState, newState)
                statusCode = obj.MotionInCollision;
                return;
            end

            newNodeId = obj.TreeInternal.insertNode(newState, idx);
            if feval(obj.GoalReachedFcn, obj, obj.CurrentGoalState, newState)
                statusCode = obj.GoalReached;
                return;
            end
            
            if newNodeId == obj.MaxNumTreeNodes
                statusCode = obj.MaxNumTreeNodesReached;
                return
            end
            
        end
        
        function cleanUp(obj)
            %cleanUp To clean up after plan

            if isa(obj.StateValidator, 'validatorOccupancyMap')
                obj.StateValidator.SkipStateValidation = false;
                obj.StateSpace.SkipStateValidation = false;
            end
            
        end
        
    end
    
    
    methods (Access = protected)
        function validateConstructorInput(obj, ss, sv)
            %validateConstructorInput
            
            validateattributes(ss, {'nav.StateSpace'}, {'scalar', 'nonempty'}, 'plannerRRT', 'stateSpace');
            validateattributes(sv, {'nav.StateValidator'}, {'scalar', 'nonempty'}, 'plannerRRT', 'stateValidator');
            if ss == sv.StateSpace % reference to the same state space object 
                obj.StateSpace = ss;
                obj.StateValidator = sv;
            else
                coder.internal.error('nav:navalgs:plannerrrt:RequireSameStateSpace');
            end
        end
        
        function cname = getClassName(obj) %#ok<MANU>
            %getClassName
            cname = 'plannerRRT';
        end
        
        function copyProperties(obj, copyObj)
            %copyProperties Copy property data from this object to a new object
            copyObj.MaxIterations = obj.MaxIterations;
            copyObj.MaxNumTreeNodes = obj.MaxNumTreeNodes;
            copyObj.MaxConnectionDistance = obj.MaxConnectionDistance;
            copyObj.GoalReachedFcn = obj.GoalReachedFcn; % double check
            copyObj.GoalBias = obj.GoalBias;
        end
        
    end
    
    % setters
    methods
        function set.GoalReachedFcn(obj, goalReachedFcn)
            %set.GoalReachedFcn Set the handle to the function that
            %   determines if goal is reached
            validateattributes(goalReachedFcn, {'function_handle'}, {'nonempty'}, getClassName(obj), 'GoalReachedFcn');
            obj.GoalReachedFcn = goalReachedFcn;
        end
        
        function set.MaxNumTreeNodes(obj, maxNumNodes)
            %set.MaxNumTreeNodes
            robotics.internal.validation.validatePositiveIntegerScalar(maxNumNodes, getClassName(obj), 'MaxNumTreeNodes');
            obj.MaxNumTreeNodes = maxNumNodes;
        end
        
        function set.MaxIterations(obj, maxIter)
            %set.MaxIterations
            robotics.internal.validation.validatePositiveIntegerScalar(maxIter, getClassName(obj), 'MaxIterations');
            obj.MaxIterations = maxIter;
        end
        
        function set.MaxConnectionDistance(obj, maxConnDist)
            %set.MaxConnectionDistance
            robotics.internal.validation.validatePositiveNumericScalar(maxConnDist, getClassName(obj), 'MaxConnectionDistance');
            obj.MaxConnectionDistance = maxConnDist;
        end
        
        function set.GoalBias(obj, goalBias)
            %set.GoalBias
            validateattributes(goalBias, {'double'}, ...
                 {'nonempty', 'scalar', 'real', 'nonnan', 'finite', '>=', 0.0, '<=', 1.0}, ...
                 getClassName(obj), 'GoalBias');
            obj.GoalBias = goalBias;
        end
        
    end
end

