clear all;
close all;
clc;

addpath("~/.wine/drive_c/femm42/mfiles");
openfemm;

%% Dimensionales del Sistema (micrómetros)
ancho_aislante = 400;
alto_aislante = 350;
ancho_medio_aquoso = 300;
alto_medio_aquoso = 250;

alto_dermis = 250;
alto_dermis_viable = 135;
alto_estrato_corneo = 15;
alto_electrodo1 = 50;

ancho_sistema = 2 * ancho_aislante + ancho_medio_aquoso;
alto_sistema = alto_dermis + alto_dermis_viable + alto_estrato_corneo + alto_aislante + alto_medio_aquoso + alto_electrodo1;

margen_aire = 2000;
ancho_aire = ancho_sistema + 2 * margen_aire;
alto_aire = alto_sistema + 2 * margen_aire;

%% Parámetros de la Prueba Única
d_actual = 50; % Distancia fijada para la prueba única
ancho_electrodo2 = ancho_aislante - d_actual;

E_ruptura = 30.0e6;
V_aplicado = 300;
e0 = 8.854187817e-12;
eps_efectiva = 80;

%% Ejecución del Solver
newdocument(1);
ei_probdef('micrometers', 'planar', 1e-8, 1, 30);

% Construcción Geométrica
ei_drawrectangle(-margen_aire, -margen_aire, ancho_sistema + margen_aire, alto_sistema + margen_aire);

suelo_actual = 0;
ei_drawrectangle(0, suelo_actual, ancho_sistema, suelo_actual + alto_dermis);
suelo_actual = suelo_actual + alto_dermis;

ei_drawrectangle(0, suelo_actual, ancho_sistema, suelo_actual + alto_dermis_viable);
suelo_actual = suelo_actual + alto_dermis_viable;

ei_drawrectangle(0, suelo_actual, ancho_sistema, suelo_actual + alto_estrato_corneo);
suelo_actual = suelo_actual + alto_estrato_corneo;

y_base_elementos = suelo_actual;

% Elementos Inferiores
ei_drawrectangle(0, suelo_actual, ancho_aislante, suelo_actual + alto_aislante);
ei_drawrectangle(0, suelo_actual, ancho_electrodo2, suelo_actual + alto_electrodo1);

x_derecha_inicio = ancho_aislante + ancho_medio_aquoso;
ei_drawrectangle(x_derecha_inicio, suelo_actual, ancho_sistema, suelo_actual + alto_aislante);
ei_drawrectangle(x_derecha_inicio + d_actual, suelo_actual, ancho_sistema, suelo_actual + alto_electrodo1);

% Elemento Superior
suelo_actual = suelo_actual + alto_aislante + alto_medio_aquoso;
ei_drawrectangle(0, suelo_actual, ancho_sistema, suelo_actual + alto_electrodo1);
ei_drawrectangle(0, 0, ancho_sistema, alto_sistema);

% Materiales y Conductores
ei_addmaterial('Kapton', 3.4, 3.4, 0);
ei_addmaterial('Medio Acuoso', 80, 80, 0);
ei_addmaterial('Estrato Corneo', 15, 15, 0);
ei_addmaterial('Dermis Viable', 80, 80, 0);
ei_addmaterial('Dermis', 100, 100, 0);
ei_addmaterial('Metal Electrodo', 1, 1, 0);
ei_addmaterial('Aire', 1, 1, 0);

ei_addconductorprop('V_Arriba', V_aplicado, 0, 1);
ei_addconductorprop('V_Abajo_Izq', 0, 0, 1);
ei_addconductorprop('V_Abajo_Der', 0, 0, 1);
ei_addconductorprop('Frontera_Cero', 0, 0, 1);

% Asignación de Bloques
ei_addblocklabel(-margen_aire/2, alto_sistema + margen_aire/2);
ei_selectlabel(-margen_aire/2, alto_sistema + margen_aire/2);
ei_setblockprop('Aire', 1, 0, 0); ei_clearselected();

x_lbl = ancho_sistema / 2;
y_lbl = alto_dermis / 2;
ei_addblocklabel(x_lbl, y_lbl); ei_selectlabel(x_lbl, y_lbl);
ei_setblockprop('Dermis', 1, 0, 0); ei_clearselected();

y_lbl = alto_dermis + (alto_dermis_viable / 2);
ei_addblocklabel(x_lbl, y_lbl); ei_selectlabel(x_lbl, y_lbl);
ei_setblockprop('Dermis Viable', 1, 0, 0); ei_clearselected();

y_lbl = alto_dermis + alto_dermis_viable + (alto_estrato_corneo / 2);
ei_addblocklabel(x_lbl, y_lbl); ei_selectlabel(x_lbl, y_lbl);
ei_setblockprop('Estrato Corneo', 1, 0, 0); ei_clearselected();

x_lbl = ancho_electrodo2 / 2; y_lbl = y_base_elementos + (alto_electrodo1 / 2);
ei_addblocklabel(x_lbl, y_lbl); ei_selectlabel(x_lbl, y_lbl);
ei_setblockprop('Metal Electrodo', 1, 0, 0); ei_clearselected();

x_lbl = ancho_aislante - (d_actual / 2); y_lbl = y_base_elementos + (alto_aislante / 2);
ei_addblocklabel(x_lbl, y_lbl); ei_selectlabel(x_lbl, y_lbl);
ei_setblockprop('Kapton', 1, 0, 0); ei_clearselected();

x_lbl = (x_derecha_inicio + d_actual) + ((ancho_sistema - (x_derecha_inicio + d_actual)) / 2);
y_lbl = y_base_elementos + (alto_electrodo1 / 2);
ei_addblocklabel(x_lbl, y_lbl); ei_selectlabel(x_lbl, y_lbl);
ei_setblockprop('Metal Electrodo', 1, 0, 0); ei_clearselected();

x_lbl = x_derecha_inicio + (d_actual / 2); y_lbl = y_base_elementos + (alto_aislante / 2);
ei_addblocklabel(x_lbl, y_lbl); ei_selectlabel(x_lbl, y_lbl);
ei_setblockprop('Kapton', 1, 0, 0); ei_clearselected();

x_lbl = ancho_aislante + (ancho_medio_aquoso / 2); y_lbl = y_base_elementos + (alto_aislante / 2);
ei_addblocklabel(x_lbl, y_lbl); ei_selectlabel(x_lbl, y_lbl);
ei_setblockprop('Medio Acuoso', 1, 0, 0); ei_clearselected();

y_electrodo_sup = y_base_elementos + alto_aislante + alto_medio_aquoso;
x_lbl = ancho_sistema / 2; y_lbl = y_electrodo_sup + (alto_electrodo1 / 2);
ei_addblocklabel(x_lbl, y_lbl); ei_selectlabel(x_lbl, y_lbl);
ei_setblockprop('Metal Electrodo', 1, 0, 0); ei_clearselected();

% Condiciones de Contorno
ei_selectsegment(ancho_electrodo2 / 2, y_base_elementos + alto_electrodo1);
ei_setsegmentprop('<None>', 0, 1, 0, 0, 'V_Abajo_Izq'); ei_clearselected();

ei_selectsegment((x_derecha_inicio + d_actual + ancho_sistema) / 2, y_base_elementos + alto_electrodo1);
ei_setsegmentprop('<None>', 0, 1, 0, 0, 'V_Abajo_Der'); ei_clearselected();

ei_selectsegment(ancho_sistema / 2, y_electrodo_sup);
ei_setsegmentprop('<None>', 0, 1, 0, 0, 'V_Arriba'); ei_clearselected();

x_mid = ancho_sistema / 2; y_mid = alto_sistema / 2;
x_max = ancho_sistema + margen_aire; y_max = alto_sistema + margen_aire;

ei_selectsegment(x_mid, -margen_aire);
ei_selectsegment(x_mid, y_max);
ei_selectsegment(-margen_aire, y_mid);
ei_selectsegment(x_max, y_mid);
ei_setsegmentprop('<None>', 0, 1, 0, 0, 'Frontera_Cero');
ei_clearselected();

% Procesamiento
ei_saveas('sim_unica.fee');
fprintf('Procesando prueba única con d = %d um...\n', d_actual);
ei_analyze();
ei_loadsolution();

% =========================================================================
% EXTRACCIÓN DE RESULTADOS FÍSICOS REALES (MÉTODO SIMULADO)
% =========================================================================
x_centro_dinamico = ancho_electrodo2 + (d_actual / 2);
y_centro_dinamico = y_base_elementos + 15;

eo_refreshview();
res_E = eo_getpointvalues(x_centro_dinamico, y_centro_dinamico);

% Corrección de Índices: 4 y 5 corresponden a Ex y Ey en V/m
if ~isempty(res_E)
    campo_maximo = sqrt(res_E(4)^2 + res_E(5)^2);
else
    res_E_respaldo = eo_getpointvalues(x_centro_dinamico + 1, y_centro_dinamico);
    if ~isempty(res_E_respaldo)
        campo_maximo = sqrt(res_E_respaldo(4)^2 + res_E_respaldo(5)^2);
    else
        campo_maximo = NaN;
    end
end

% Extracción de Capacitancia Real
res_circ = eo_getconductorproperties('V_Arriba');
Q_real = res_circ(2);
capacitancia = (abs(Q_real) / 100) * 1e12;

% Factor de Seguridad real frente a la ruptura
if ~isnan(campo_maximo) && campo_maximo > 0
    factor_seguridad = E_ruptura / campo_maximo;
else
    factor_seguridad = NaN;
end

eo_close();

% =========================================================================
% IMPRESIÓN DE RESULTADOS EN CONSOLA
% =========================================================================
fprintf('\n=========================================\n');
fprintf('        RESULTADOS DE LA PRUEBA ÚNICA      \n');
fprintf('=========================================\n');
fprintf('Distancia de prueba (d)   : %2.1f um\n', d_actual);
fprintf('Capacitancia del Sistema  : %e pF\n', capacitancia);
fprintf('Campo Eléctrico Máximo    : %4.2f V/m\n', campo_maximo);
fprintf('Factor de Seguridad (FS)  : %4.2f\n', factor_seguridad);
fprintf('=========================================\n');
