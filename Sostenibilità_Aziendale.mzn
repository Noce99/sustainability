% Use this editor as a MiniZinc scratch book
int: revenue;
int: green_investment;
int: i_type;
%1 -> Relevance
%2 -> Automotive & Machine
%3 -> Chemical & Pharmaceutical
%4 -> FMCG
%5 -> Packaging


% Relevance
array [1..5, 1..10] of int: raw_materials_global;
array [1..5, 1..8] of int: packaging_global;
array [1..5, 1..7] of int: equipment_global;
array [1..5, 1..6] of int: logistic_global;
raw_materials_global = [| 431, 420, 407, 406, 391, 388, 387, 383, 373, 364
                        | 421, 425, 389, 371, 407, 396, 364, 389, 368, 329
                        | 414, 393, 390, 400, 357, 383, 366, 341, 331, 331
                        | 439, 422, 418, 422, 392, 384, 400, 396, 390, 398
                        | 400, 475, 425, 375, 375, 350, 400, 375, 400, 350 |];
packaging_global = [| 424, 417, 406, 404, 387, 380, 377, 344
                    | 425, 418, 386, 382, 389, 375, 370, 331
                    | 410, 403, 379, 376, 348, 343, 366, 310
                    | 429, 422, 418, 418, 398, 394, 384, 310
                    | 425, 350, 425, 425, 375, 400, 350, 310 |];
equipment_global = [| 442, 424, 414, 392, 384, 368, 365
                    | 436, 407, 414, 382, 375, 382, 371
                    | 424, 417, 414, 362, 379, 355, 338
                    | 446, 430, 406, 408, 380, 359, 365
                    | 425, 375, 425, 375, 425, 325, 375 |];
logistic_global = [| 426, 425, 416, 395, 377, 349
                   | 414, 429, 414, 414, 393, 350
                   | 424, 424, 397, 383, 348, 328
                   | 433, 424, 422, 348, 384, 359
                   | 350, 375, 375, 328, 325, 350 |];

% Assessment Difficulty
array [1..10] of 1..500: raw_materials_cost;
array [1..8] of 1..500: packaging_cost;
array [1..7] of 1..500: equipment_cost;
array [1..6] of 1..500: logistic_cost;
raw_materials_cost = [279, 382, 349, 287, 307, 265, 279, 287, 284, 230];
packaging_cost = [366, 308, 285, 280, 355, 358, 255, 299];
equipment_cost = [364, 359, 344, 342, 310, 325, 289];
logistic_cost = [379, 311, 333, 363, 293, 307];

% Limits on the possible improvement
array [1..10] of 1..1000: raw_materials_limit = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
array [1..8] of 1..1000: packaging_limit = [1, 1, 1, 1, 1, 1, 1, 1];
array [1..7] of 1..1000: equipment_limit = [1, 1, 1, 1, 1, 1, 1];
array [1..6] of 1..1000: logistic_limit = [1, 1, 1, 1, 1, 1];

array [1..10] of var 0..1000: raw_materials_choice;
array [1..8] of var 0..1000: packaging_choice;
array [1..7] of var 0..1000: equipment_choice;
array [1..6] of var 0..1000: logistic_choice;

var int: total_raw_cost = sum(i in 1..10)(raw_materials_choice[i] * raw_materials_cost[i] * revenue);
var int: total_packaging_cost = sum(i in 1..8)(packaging_choice[i] * packaging_cost[i] * revenue);
var int: total_equipment_cost = sum(i in 1..7)(equipment_choice[i] * equipment_cost[i] * revenue);
var int: total_logistic_cost = sum(i in 1..6)(logistic_choice[i] * logistic_cost[i] * revenue);
var int: total_cost = total_raw_cost + total_packaging_cost + total_equipment_cost + total_logistic_cost;
constraint total_cost <= green_investment * 100000;

constraint forall(i in 1..10)(raw_materials_choice[i] <= raw_materials_limit[i]);
constraint forall(i in 1..8)(packaging_choice[i] <= packaging_limit[i]);
constraint forall(i in 1..7)(equipment_choice[i] <= equipment_limit[i]);
constraint forall(i in 1..6)(logistic_choice[i] <= logistic_limit[i]);

var int: total_raw_value = sum(i in 1..10)(raw_materials_choice[i] * raw_materials_global[i_type, i]);
var int: total_packaging_value = sum(i in 1..8)(packaging_choice[i] * packaging_global[i_type, i]);
var int: total_equipment_value = sum(i in 1..7)(equipment_choice[i] * equipment_global[i_type, i]);
var int: total_logistic_value = sum(i in 1..6)(logistic_choice[i] * logistic_global[i_type, i]);

var int: value = total_raw_value + total_packaging_value + total_equipment_value + total_logistic_value;

solve maximize value;

output ["{", show(raw_materials_choice), show(packaging_choice), show(equipment_choice), show(logistic_choice),
"\nvalue: ", show(value),
"\ncost: ", show(total_cost/100000), "}\n"];
