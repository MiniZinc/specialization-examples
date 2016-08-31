% products 
enum PRODUCT;  
% Profit per unit for each product
array[PRODUCT] of float: profit; 

% resources
enum RESOURCE; 
% Amount of each resource available
array[RESOURCE] of float: capacity; 

% Units of each resource required to produce 
%       1 unit of product
array[PRODUCT,RESOURCE] of float: consumption; 

% Variables: how much should we make of each product
array[PRODUCT] of var int: produce;

% Must produce a non-negative amount
constraint forall(p in PRODUCT)
			   (produce[p] >= 0);

% Production can only use the available resources:
constraint forall (r in RESOURCE)(
 sum (p in PRODUCT)(consumption[p, r] * produce[p]) <= capacity[r]
); 

% Maximize profit
solve maximize sum(p in PRODUCT)   
                  (profit[p]*produce[p]);

output [ "\(p): \(produce[p])\n" | p in PRODUCT ]++["PROFIT: \(sum(p in PRODUCT)(profit[p]*produce[p]))"];