
clear all;

global A = csvread('sensor_data.csv');  #do not change this line

#global C = csvread('csv_output_eyantra.csv');  #do not change this line

global on1_accx =0;   # holds value of y[n-1] for x-axis of accelerometer
global on1_accy =0;   # holds value of y[n-1] for y-axis of accelerometer
global on1_accz =0;   # holds value of y[n-1] for z-axis of accelerometer
global on1_gyrx =0;   # holds value of y[n-1] for x-axis of gyroscope
global on1_gyry =0;   # holds value of y[n-1] for y-axis of gyroscope
global on1_gyrz =0;   # holds value of y[n-1] for z-axis of gyroscope
global in1_gyrx =0;   # holds value of x[n-1] for x-axis of gyroscope
global in1_gyry=0;    # holds value of x[n-1] for y-axis of gyroscope
global in1_gyrz=0;    # holds value of x[n-1] for z-axis of gyroscope
global angle_pitch = 0;   # holds value of pitch angle
global angle_roll = 0;    # holds value of roll angle

################################################
#######Declare your global variables here#######
################################################

function acc_filter=read_accel(axl,axh,ayl,ayh,azl,azh)  
  
  #################################################
  ####### Write a code here to combine the ########
  #### HIGH and LOW values from ACCELEROMETER #####
  #################################################
  
  ## conversion of 8-bit raw data to 16-bit signed data for accelerometer  ##
  
  axl = dec2bin (axl,8);
  axh = dec2bin (axh,8);
  ax = strcat(axh,axl);
  ax = bin2dec(ax);
  if ax>32767
    ax = ax - 65536;
  endif
  
  
  ayl = dec2bin (ayl,8);
  ayh = dec2bin (ayh,8);
  ay = strcat(ayh,ayl);
  ay = bin2dec(ay);
  if ay>32767
    ay = ay - 65536;
  endif
  
  
  azl = dec2bin (azl,8);
  azh = dec2bin (azh,8);
  az = strcat(azh,azl);
  az = bin2dec(az);
  if az>32767
    az = az - 65536;
  endif
  
  
  ####################################################
  # Call function lowpassfilter(ax,ay,az,f_cut) here #
  ####################################################
  #disp([ax,ay,az])

  acc_filter = lowpassfilter(ax,ay,az,5);

endfunction

function gyro_filter=read_gyro(gxl,gxh,gyl,gyh,gzl,gzh)
  
  #################################################
  ####### Write a code here to combine the ########
  ###### HIGH and LOW values from GYROSCOPE #######
  #################################################
  
  ## conversion of 8-bit raw data to 16-bit signed data for gyroscope  ##
  
  gxl = dec2bin (gxl,8);
  gxh = dec2bin (gxh,8);
  gx = strcat(gxh,gxl);
  gx = bin2dec(gx);
  if gx > 32767
    gx = gx - 65536;
  endif
  
  
  gyl = dec2bin (gyl,8);
  gyh = dec2bin (gyh,8);
  gy = strcat(gyh,gyl);
  gy = bin2dec (gy);
  if gy>32767
    gy = gy - 65536;
  endif
  
  
  gzl = dec2bin (gzl,8);
  gzh = dec2bin (gzh,8);
  gz = strcat(gzh,gzl);
  gz = bin2dec (gz);
  if gz>32767
    gz = gz - 65536;
  endif
  
  
  #####################################################
  # Call function highpassfilter(ax,ay,az,f_cut) here #
  #####################################################;
  
  gyro_filter = highpassfilter(gx,gy,gz,5);
  
endfunction

function On_acc = lowpassfilter(ax,ay,az,f_cut)
  
  ## scaling factor for accelerometer ##
  scale_acc = 16384;
  
  global on1_accx;
  global on1_accy;
  global on1_accz;
  
  dT = 1/100;  #time in seconds
  Tau = 1/(2*pi*f_cut);
  alpha = Tau/(Tau+dT);              #do not change this line
  
  ################################################
  ##############Write your code here##############
  ################################################
  
  ## pass raw data of accelerometer to lowpassfilter for each axis ##
  
  On_x = ((1-alpha)*ax) + (alpha*on1_accx);
  on1_accx = On_x;
  On_y = ((1-alpha)*ay) + (alpha*on1_accy);
  on1_accy = On_y;
  On_z = ((1-alpha)*az) + (alpha*on1_accz);
  on1_accz = On_z;
  
  On_acc = [On_x/scale_acc,On_y/scale_acc,On_z/scale_acc];
  
endfunction

function On_gyr = highpassfilter(gx,gy,gz,f_cut)  
  
  ## scaling factor for gyroscope ##
  scale_gyr = 131;

  global on1_gyrx;
  global on1_gyry;
  global on1_gyrz;
  global in1_gyrx;
  global in1_gyry;
  global in1_gyrz;
  
  dT = 1/100;  #time in seconds
  Tau = 1/(2*pi*f_cut);
  alpha = Tau/(Tau+dT);             #do not change this line
  
  ################################################
  ##############Write your code here##############
  ################################################
  
  ## pass raw data of gyroscope to highpassfilter for each axis ##
  
  On_x = (1-alpha)*on1_gyrx + (1-alpha)*(gx-in1_gyrx); 
  on1_gyrx = On_x;
  in1_gyrx = gx;
  On_y = (1-alpha)*on1_gyry + (1-alpha)*(gy-in1_gyry);
  on1_gyry = On_y;
  in1_gyry = gy;
  On_z = (1-alpha)*on1_gyrz + (1-alpha)*(gz-in1_gyrz);
  on1_gyrz = On_z;
  in1_gyrz = gz;
  
  
  On_gyr = [On_x/scale_gyr,On_y/scale_gyr,On_z/scale_gyr];
  
endfunction

function pitch = comp_filter_pitch(ay,az,gx)
  alpha = 0.03;
  dt = 0.01;
  global angle_pitch;
  
  ##############################################
  ####### Write a code here to calculate  ######
  ####### PITCH using complementry filter ######
  ##############################################
  
  acc_data = atan(ay/abs(az))* 57.295;
  gyr_data = -gx;
  
  ## combining filtered value of lowpassfilter and highpassfilter ##
  ## to calculate pitch angle ##
  
  angle_pitch=((1-alpha)*(angle_pitch+(gyr_data*dt)))+(alpha*acc_data);
  pitch = angle_pitch;
  
endfunction

function roll = comp_filter_roll(ax,az,gy)
  alpha = 0.03;
  dt = 0.01;
  global angle_roll;

  ##############################################
  ####### Write a code here to calculate #######
  ####### ROLL using complementry filter #######
  ##############################################

  acc_data = atan(ax/abs(az))* 57.295;
  gyr_data = -gy;
  
  ## combining filtered value of lowpassfilter and highpassfilter ##
  ## to calculate roll angle ##
  
  angle_roll=((1-alpha)*(angle_roll+(gyr_data*dt)))+(alpha*acc_data);
  roll = angle_roll;
  
endfunction
 
function execute_code
  global A;
  #global C;
  B = [];
  for n = 1:rows(A)                    #do not change this line
    #disp(n);
    ax_h = A(n,1);
    ax_l = A(n,2);
    ay_h = A(n,3);
    ay_l = A(n,4);
    az_h = A(n,5);
    az_l = A(n,6);
    gx_h = A(n,7);
    gx_l = A(n,8);
    gy_h = A(n,9);
    gy_l = A(n,10);
    gz_h = A(n,11);
    gz_l = A(n,12);
    
    filtered_acc = read_accel(ax_l,ax_h,ay_l,ay_h,az_l,az_h);
    filtered_gyr = read_gyro(gx_l,gx_h,gy_l,gy_h,gz_l,gz_h);
    
    ###############################################
    ####### Write a code here to calculate  #######
    ####### PITCH using complementry filter #######
    ###############################################
    
    B(n,1) = comp_filter_pitch(filtered_acc(2),filtered_acc(3),filtered_gyr(1));
    
    B(n,2) = comp_filter_roll(filtered_acc(1),filtered_acc(3),filtered_gyr(2));
    
  endfor
  csvwrite('output_data.csv',B);        #do not change this line
  #plot(B(1:1000,1),color='b',C(1:1000,1),color='r');
endfunction

execute_code                           #do not change this line
