% products 
enum PRODUCT;  
% Profit per unit for each product
array[PRODUCT] of float: profit;
constraint forall(p in PRODUCT)
   (assert(profit[p] >= 0, "profit[\(p)] < 0!"));

% resources
enum RESOURCE; 
% Amount of each resource available
array[RESOURCE] of float: capacity; 
constraint forall(r in RESOURCE)
   (assert(capacity[r] >= 0, "capacity[\(r)] < 0!"));


% Units of each resource required to produce 
%       1 unit of product
array[PRODUCT,RESOURCE] of float: consumption; 
constraint forall(p in PRODUCT, r in RESOURCE)
   (assert(consumption[p, r] >= 0, "consumption[\(p),\(r)] < 0!"));

% Variables: how much should we make of each product
array[PRODUCT] of var int: produce;

% Must produce a non-negative amount
constraint forall(p in PRODUCT)
			   (produce[p] >= 0);

% Production can only use the available resources:
constraint forall(r in RESOURCE)
   (sum(p in PRODUCT)(consumption[p, r] * produce[p]) 
      <= capacity[r]); 

% Maximize profit
solve maximize sum(p in PRODUCT)(profit[p]*produce[p]);

output [ "\(p): \(produce[p])\n" | p in PRODUCT ]++["PROFIT: \(sum(p in PRODUCT)(profit[p]*produce[p]))"];