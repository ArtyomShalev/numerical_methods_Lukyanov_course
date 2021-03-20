%student: Shalev Artyom Z4145
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
%------------------------- определение фазовой скорости с (без учета
%свойств препятсвия) -------------------------------------------------
c = 1/sqrt(mu0*ee0);   %фазовая скорость
f = 100*1e6; %частота МГц
lyambda = c/f; %наибольшая длина волны
dlyambda = round(lyambda/lyambda*dd); %шаг по длине волны в ячейках
A = 100; %амплитуда 100 мкВ
% ---- определение пространтсвенной дискреты dx, dy, dz ------
dy = c / (dd*f); %длина ячейки вдоль оси OY
dz = dy; %длина ячейки вдоль оси OZ
dx = dy; %длина ячейки вдоль оси OX
% ----------- определение временной дискреты dt --------------------
dt = dy / (sqrt(3)*c);
% определение размеров пространства и препятствия и времени наблюдения
Space = round(10*dd*sqrt(3)); % время наблюдения за распространением ЭМВ
% ----- количество длин волн вдоль оси координат
% ----- количество ячеек вдоль оси координат
nx = round(10*dlyambda/1); %nx - ширина расчетной области в ячейках
ny = round(10*dlyambda/1); %ny - ширина расчетной области в ячейках
nz = round(10*dlyambda/1); %nz - ширина расчетной области в ячейках
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
Ez = zeros(nx, ny, nz);
Ex = zeros(nx, ny, nz);
Ey = zeros(nx, ny, nz);
Hz = zeros(nx, ny, nz);
Hx = zeros(nx, ny, nz);
Hy = zeros(nx, ny, nz);

% Присвоение расчетной области параметров свободного пространства
EzKe = Ke1.*ones(nx, ny, nz);
ExKe = Ke1.*ones(nx, ny, nz);
EyKe = Ke1.*ones(nx, ny, nz);
EzEk = Ek1.*ones(nx, ny, nz);
ExEk = Ek1.*ones(nx, ny, nz);
EyEk = Ek1.*ones(nx, ny, nz);

% Задание параметров пирамиды с квадратным основанием
l = round(nx/2); %длина области, которую занимает пирамида
w = round(ny/2); %ширина области, которую занимает пирамида
h = round(w/2); %высота пирамиды(в данном алгоритме высота должна строго равняться половине ширины области)
% ----- позиция пирамиды в пространстве --------------------------------
x_pos = round(nx/2)-round(l/2);
y_pos = round(ny/2)-round(w/2);
z_pos = round(nz/2)-round(h/2);

for i=0:h
    EzKe(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ke2;
    ExKe(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ke2;
    EyKe(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ke2;
    
    EzEk(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ek2;
    ExEk(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ek2;
    EyEk(x_pos+i:x_pos+l-i, y_pos+i:y_pos+w-i, z_pos+i) = Ek2;
end

%Визуализация фигуры
% mask=EzKe;
% b_mask=mask==Ke2;
% figure;
% blockPlot(b_mask);
% axis([1 nx 1 ny 1 nz]);
% grid on;
% view (45, 45);

movie = VideoWriter('video.avi');  % создание объекта для записи видео
open(movie);  %открытие объекта для записи видео
 for n=1:Space 
Ez(1:nx,1,1:nz)=A*sin(2*pi*f*n*dt); %plane wave

clear i j k
i = 1:nx;
j = 1:ny-1;
k = 1:nz-1;
Hx(i,j,k) = Hx(i,j,k)-Kh.*((Ez(i,j+1,k)-Ez(i,j,k))/dy -(Ey(i,j,k+1)-Ey(i,j,k))/dz);

clear i j k
i = 1:nx-1;
j = 1:ny;
k = 1:nz-1;
Hy(i,j,k) = Hy(i,j,k)-Kh.*((Ex(i,j,k+1)-Ex(i,j,k))/dz - (Ez(i+1,j,k)-Ez(i,j,k))/dx);

clear i j k
i = 1:nx-1;
j = 1:ny-1;
k = 1:nz;
Hz(i,j,k) = Hz(i,j,k)-Kh.*((Ey(i+1,j,k)-Ey(i,j,k))/dx - (Ex(i,j+1,k)-Ex(i,j,k))/dy);

clear i j k
i = 1:nx;
j = 2:ny;
k = 2:nz;
Ex(i,j,k) = Ex(i,j,k).*ExKe(i,j,k)+ExEk(i,j,k).*((Hz(i,j,k)-Hz(i,j-1,k))/dy - (Hy(i,j,k)-Hy(i,j,k-1))/dz);

clear i j k
i = 2:nx;
j = 1:ny;
k = 2:nz;
Ey(i,j,k) = Ey(i,j,k).*EyKe(i,j,k)+EyEk(i,j,k).*((Hx(i,j,k)-Hx(i,j,k-1))/dz - (Hz(i,j,k)-Hz(i-1,j,k))/dx);

clear i j k
i = 2:nx;
j = 2:ny;
k = 1:nz;
Ez(i,j,k) = Ez(i,j,k).*EzKe(i,j,k)+EzEk(i,j,k).*((Hy(i,j,k)-Hy(i-1,j,k))/dx - (Hx(i,j,k)-Hx(i,j-1,k))/dy);


%--Визуализация моделирования. Анимация распространения ЭМП по заданному срезу
EZ(:,:,1) = Ez(:,:,nz/2);
[X,Y] = meshgrid(1:nx, 1:ny); %создание 2Д-сетки
surf(X,Y,EZ); %построение поверхности
caxis([-1 1]); %установка пределов цветной легенды
shading interp; %изменяет цвет каждой клетки плавно (происходит интерполяция цветов в узлах сетки
colormap jet; %установка цветовой палитры (от синего до красного)
c = colorbar('Location', 'WestOutside'); %отображение палитры на рисунке
ylabel(c, 'Ez(V/m)');  %вывод единицы измерения рядом с палитрой 
grid on;

view(90, 90);  %позиция записи видео http://matlab.izmiran.ru/help/techdoc/ref/view.html
rect = [0 0 550 420]; %задание прямоугольной области, непонятно зачем
F = getframe(gcf, rect); %получение кадра картинки через surf
writeVideo(movie, F); %запись видео под названием "movie"
end
close(movie);