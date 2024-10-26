% Given states
s01 = 1.1;
st = 1;

% Known edge weights
e0102 = 0.8;
e0210 = 0.5;
e0409 = 1.3;
e0507 = 0.7;
e0613 = 0.9;
e0815 = 1.1;
e1013 = 0.8;
e1214 = 1;
e1317 = 0.7;
e1415 = 1.2;
e18t = 1.5;

% Number of nodes
num_nodes = 19;

% Initialize known states
s = ones(num_nodes, 1);
s(1) = s01;
s(num_nodes) = st;

% Initialize edge weight matrix
edge_weights =zeros(num_nodes, num_nodes);

% Assign known edge weights
edge_weights(1, 2) = e0102; edge_weights(2, 1)= e0102;
edge_weights(2, 10) = e0210; edge_weights(10, 2) = e0210;
edge_weights(4, 9) = e0409;  edge_weights(9, 4) = e0409; 
edge_weights(5, 7) = e0507; edge_weights(7, 5) = e0507;
edge_weights(6, 13) = e0613; edge_weights(13, 6) = e0613;
edge_weights(8, 15) = e0815; edge_weights(15, 8) = e0815;
edge_weights(10, 13) = e1013; edge_weights(13, 10) = e1013;
edge_weights(12, 14) = e1214; edge_weights(14, 12) = e1214;
edge_weights(13, 17) = e1317; edge_weights(17, 13) = e1317;
edge_weights(14, 15) = e1415; edge_weights(15, 14) = e1415;
edge_weights(18, num_nodes) = e18t; edge_weights(num_nodes, 18) = e18t;

% Initialize transmitted and received signal
 transmitted_signal=zeros(num_nodes, num_nodes);
 received_signal=zeros(num_nodes, num_nodes);

% Set convergence threshold
convergence_threshold = 0.0001;


% Start iterative state update
converged = false;
k=0;
store_s=zeros(19,7412);
while ~converged    % ~ means calculate logical NOT
    k=k+1
    store_s(1:19,k)=s;
    new_states = s
    
    transmitted_signal_sum=0;
    received_signal_sum=0;
    
    for v = 2:num_nodes-1
        % Calculate transmitted signal     
        for i=1:v-1
            transmitted_signal(i,v) = s(i)*edge_weights(i,v);
        end
        % Calculate received signal
        for j=v+1:19
            received_signal(j,v) = s(v)*edge_weights(j,v);
        end    
        % Update the state of node v
        for m=1:19
            transmitted_signal_sum=transmitted_signal_sum+transmitted_signal(m,v); 
        end
        for n=1:19
            received_signal_sum=received_signal_sum+received_signal(n,v);
        end    
        new_states(v) = transmitted_signal_sum - received_signal_sum;
    end
    
    % Check for convergence
    if max(abs(new_states - s)) < convergence_threshold
        converged = true;
    end
    
    s = new_states;
end

% Display the final states and edge weights
disp('Final Node States:');
disp(s);

disp('Final Edge Weights:');
disp(edge_weights);

