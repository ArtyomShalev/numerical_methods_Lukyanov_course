clear all
%ввод исходных данных
%-------------------------- объявление констант ------------------------------------
mu0 = pi*4*1e-7; %магнитная постоянная
ee0 = 1e-9/(pi*36); %электрическая постоянная
dd = 10; %дискретизация длины волны 1/10
%----------------------------------------------------------------------
ss1 = 0; %удельная проводимость среды
ss2 = 1e+12; %удельная проводимость препятствия (идеально проводящее тело)
ss3 = 1e-15; %удельная проводимость препятствия (FR-4)
ss4 = 1e-15; %удельная проводимость препятствия (кварцевое стекло)
ee1 = 1; %отн. диэл. проницаемость среды 
ee2 = 1; %отн. диэл. проницаемость препятствия (идеально проводящее тело)
ee3 = 4.3; %отн. диэл. проницаемость препятствия (FR-4)
ee4 = 3.8; %отн. диэл. проницаемость препятствия (кварцевое стекло)
mu1 = 1; %отн. магн. проницаемость среды 
mu2 = 1; %отн. магн. проницаемость препятствия (идеально проводящее тело)
mu3 = 1; %отн. магн. проницаемость препятствия (FR-4)
mu4 = 1; %отн. магн. проницаемость препятствия (кварцевое стекло)
EE1 = ee0 * ee1; %абс. диэл. проницаемость среды 
EE2 = ee0 * ee2; %абс. диэл. проницаемость препятствия (идеально проводящее тело)
EE3 = ee0 * ee3; %абс. диэл. проницаемость препятствия (FR-4)
EE4 = ee0 * ee4; %абс. диэл. проницаемость препятствия (кварцевое стекло)
MU1 = mu0 * mu1; %абс. магн. проницаемость среды
MU2 = mu0 * mu2; %абс. магн. проницаемость препятствия (идеально проводящее тело)
MU3 = mu0 * mu3; %абс. магн. проницаемость препятствия (FR-4)
MU4 = mu0 * mu4; %абс. магн. проницаемость препятствия (кварцевое стекло)
tt0 = 1; %начальный временной шаг
%------------------------- определение фазовой скорости с (без учета
%свойств препятсвия) -------------------------------------------------
c = 1/sqrt(mu0*ee0);   %фазовая скорость
f = 100*1e6; %частота МГц
lyambda = c/f; %наибольшая длина волны
dlyambda = round(lyambda/lyambda*dd); %шаг по длине волны в ячейках
A = 100; %амплитуда 100 мкВ
%L_PGU = введутся позже
%PGU = 
% ---- определение пространтсвенной дискреты dx, dy, dz ------
dy = c / (dd*f); %длина ячейки вдоль оси OY
dz = dy; %длина ячейки вдоль оси OZ
dx = dy; %длина ячейки вдоль оси OX
% ----------- определение временной дискреты dt --------------------
dt = dy / (sqrt(3)*c);
% определение размеров пространства и препятствия и времени наблюдения
Space = round(5*dd*sqrt(3)); % время наблюдения за распространением ЭМВ
% ----- количество длин волн вдоль оси координат
% ----- количество ячеек вдоль оси координат
nx = round(10*dlyambda/1); %nx - ширина расчетной области в ячейках
% ------ определение коэффициентов Kh, Ke, Ek ------------------------
Kh = dt/MU1; % коэффициент при Н
Ke1 = (1-((dt*ss1)/(2*EE1)))/(1+((dt*ss1)/(2*EE1))); % коэффициент при Е свободного пространтства
Ke2 = (1-((dt*ss2)/(2*EE2)))/(1+((dt*ss2)/(2*EE2))); % коэффициент при Е препятствия
Ke3 = (1-((dt*ss3)/(2*EE3)))/(1+((dt*ss3)/(2*EE3))); % коэффициент при Е препятствия FR-4 
Ke4 = (1-((dt*ss4)/(2*EE4)))/(1+((dt*ss4)/(2*EE4))); % коэффициент при Е препятствия (кварцевое стекло)
Ek1 = (2*dt)/(2*EE1+dt*ss1); % коэффициент при потерях свободного пространтства
Ek2 = (2*dt)/(2*EE2+dt*ss2); % коэффициент при потерях препятствия
Ek3 = (2*dt)/(2*EE3+dt*ss3); % коэффициент при потерях препятствия FR-4
Ek4 = (2*dt)/(2*EE4+dt*ss4); % коэффициент при потерях препятствия (кварцевое стекло)

% ----- определение векторов в йчейке КРВО ------------
Ez = zeros(nx);
Hy = zeros(nx);

% Присвоение расчетной области параметров свободного пространства
EzKe = Ke1.*ones(nx);
EzEk = Ek1.*ones(nx);

% movie = VideoWriter('video.avi');  % создание объекта для записи видео
% open(movie);  %открытие объекта для записи видео

for n = 1:Space
U = A*sin(2*pi*f*n*dt); %напряжение изменяется по гармоническому закону
Ez(nx/2) = -U/dx; %источник излучения находится в центре расчетной области


%UPDATE EQUATIONS DUE TO THE JOHN B. SCHNEIDER
% Отображение прогресса вычислений
% n
% Space 

%-------------------------------------------------------------------------------------------------------
%--Визуализация моделирования. Анимация распространения ЭМП по заданному срезу
% EZ(:,:,1) = Ez(nx/2,:,:);
% [X,Y] = meshgrid(1:ny, 1:nz); %создание 2Д-сетки
% surf(X,Y,EZ); %построение поверхности
% caxis([-1 1]); %установка пределов цветной легенды
% shading interp; %изменяет цвет каждой клетки плавно (происходит интерполяция цветов в узлах сетки
% colormap jet; %установка цветовой палитры (от синего до красного)
% c = colorbar('Location', 'WestOutside'); %отображение палитры на рисунке
% ylabel(c, 'Ez(V/m)');  %вывод единицы измерения рядом с палитрой 
% grid on;
% 
% view(90, 90);  %позиция записи видео http://matlab.izmiran.ru/help/techdoc/ref/view.html
% rect = [0 0 550 420]; %задание прямоугольной области, непонятно зачем
% F = getframe(gcf, rect); %получение кадра картинки через surf
% writeVideo(movie, F); %запись видео под названием "movie"

%-------------------------------------------------------------------------------------------------------

%-------------------------------------------------------------------------------------------------------
%Визуализация моделирования.
%График амплитудного значения z-компоненты электрического поля в произвольном сечении
% [X,Y] = meshgrid(1:nx,1:ny);
% Z = abs(Ez(:,:,nz/2+nz/4));
% surf(X,Y,Z);
% shading interp;
% colormap jet;
%-------------------------------------------------------------------------------------------------------

%Запись мгновенного значения z-составляющей поля E в произвольной точке
Y(n) = abs(Ez(nx/2,ny/2,nz/2));

end;

%-------------------------------------------------------------------------------------------------------
%Визуализация моделирования.
%График мгновенного значения z-компоненты поля Е в произвольном точке
time_start = 0;
time_end = 1/(Space*c);
time_step = time_end/Space;
time = time_start:time_step:time_end - time_step;
plot(time,Y,'r','LineWidth',2);
title('Ez(t) in (nx/2,ny/2,nz/2) coordinates');
ylabel('Ez, uV/m');
xlabel('t, s');
%-------------------------------------------------------------------------------------------------------


% close(movie); %закрытие объекта для записи видео



