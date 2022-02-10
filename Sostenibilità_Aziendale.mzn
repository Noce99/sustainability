% Use this editor as a MiniZinc scratch book
int: available_money;

array [1..10] of 1..500: raw_materials_global;
array [1..8] of 1..500: packaging_global;
array [1..7] of 1..500: equipment_global;
array [1..6] of 1..500: logistic_global;
raw_materials_global = [431, 420, 407, 406, 391, 388, 387, 383, 373, 364];
packaging_global = [424, 417, 406, 404, 387, 380, 377, 344];
equipment_global = [442, 424, 414, 392, 384, 368, 365];
logistic_global = [426, 425, 416, 395, 377, 349];
array [1..10] of 1..500: raw_materials_cost;
array [1..8] of 1..500: packaging_cost;
array [1..7] of 1..500: equipment_cost;
array [1..6] of 1..500: logistic_cost;
raw_materials_cost = [279, 382, 349, 287, 307, 265, 279, 287, 284, 230];
packaging_cost = [366, 308, 285, 280, 355, 358, 255, 299];
equipment_cost = [364, 359, 344, 342, 310, 325, 289];
logistic_cost = [379, 311, 333, 363, 293, 307];

% Limits on the possible improvement
array [1..10] of 1..1000: raw_materials_limit = [3, 3, 3, 3, 3, 3, 3, 3, 3, 3];
array [1..8] of 1..1000: packaging_limit = [3, 3, 3, 3, 3, 3, 3, 3];
array [1..7] of 1..1000: equipment_limit = [3, 3, 3, 3, 3, 3, 3];
array [1..6] of 1..1000: logistic_limit = [3, 3, 3, 3, 3, 3];

array [1..10] of var 0..1000: raw_materials_choice;
array [1..8] of var 0..1000: packaging_choice;
array [1..7] of var 0..1000: equipment_choice;
array [1..6] of var 0..1000: logistic_choice;

var int: total_raw_cost = sum(i in 1..10)(raw_materials_choice[i] * raw_materials_cost[i]);
var int: total_packaging_cost = sum(i in 1..8)(packaging_choice[i] * packaging_cost[i]);
var int: total_equipment_cost = sum(i in 1..7)(equipment_choice[i] * equipment_cost[i]);
var int: total_logistic_cost = sum(i in 1..6)(logistic_choice[i] * logistic_cost[i]);
var int: total_cost = total_raw_cost + total_packaging_cost + total_equipment_cost + total_logistic_cost;
constraint total_cost <= available_money;

constraint forall(i in 1..10)(raw_materials_choice[i] <= raw_materials_limit[i]);
constraint forall(i in 1..8)(packaging_choice[i] <= packaging_limit[i]);
constraint forall(i in 1..7)(equipment_choice[i] <= equipment_limit[i]);
constraint forall(i in 1..6)(logistic_choice[i] <= logistic_limit[i]);

var int: total_raw_value = sum(i in 1..10)(raw_materials_choice[i] * raw_materials_global[i]);
var int: total_packaging_value = sum(i in 1..8)(packaging_choice[i] * packaging_global[i]);
var int: total_equipment_value = sum(i in 1..7)(equipment_choice[i] * equipment_global[i]);
var int: total_logistic_value = sum(i in 1..6)(logistic_choice[i] * logistic_global[i]);

var int: value = total_raw_value + total_packaging_value + total_equipment_value + total_logistic_value;

solve maximize value;

output ["{", show(raw_materials_choice), show(packaging_choice), show(equipment_choice), show(logistic_choice),
"\nvalue: ", show(value),
"\ncost: ", show(total_cost), "}\n"];
