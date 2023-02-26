%%Mostly based on tusx setup tutorial with some modifications


% File of binary skull mask
skullMask_filename = fullfile('assets', 'visibleHuman_headCT_mask1300.nii.gz');

%location of ultrasound tranducer
scalpLocation = [145 200 440];
ctxTarget = [190 175 2100];

% Ultrasound transducer parameters
transducer.focalLength_m = 0.03;    
transducer.freq_MHz = 0.5;          
transducer.source_mag_Pa = 0.66e6;  

% % Upscaling
scale = 2; 

trimSize = 256; 

reorientToGrid = true; 

% % Mask smoothing
initialSmooth = true;

%   Set whether to run k-Wave on an NVIDIA GPU or not
runOnGPU = false;

CFLnumber = 0.3;

% Acoustic properties
%   Skull
skull = struct;
skull.density       = 1732; % [kg/m^3]
skull.speed         = 2850; % [m/s]
skull.alphaCoeff    = 8.83; % [dB/(MHz^y cm)]

%   AlphaPower
alphaPower = 1.43;

% % Run tusx_sim_setup
[kgrid, medium, source, sensor, input_args, infoStruct, grids] =...
    tusx_sim_setup(skullMask_filename, scalpLocation, ctxTarget, scale, alphaPower,...
    'CFLnumber', CFLnumber, 'skull', skull,...
    'reorientToGrid', reorientToGrid, 'trimSize', trimSize,...
    'initialSmooth', initialSmooth, 'runOnGPU', runOnGPU,...
    'transducer', transducer);

%% Visualize positioning
% Create a label volume with skull and ultrasound transducer
skullAndTransducer = viewTransducerPlacement_labels(medium.density, source.p_mask);

% Open label volume in Volume Viewer app
volumeViewer(skullAndTransducer, 'VolumeType', 'Labels')

%% Feed TUSX outputs into k-Wave
sensor_data = kspaceFirstOrder3D(kgrid, medium, source, sensor, input_args{:});

%% Visualize

% Convert vector to volume
if runOnGPU
    % Gather results from GPU back to CPU normal workspace
    sensor_data.p_max   = gather(sensor_data.p_max);
    sensor_data.p_rms   = gather(sensor_data.p_rms);
    sensor_data.p_final = gather(sensor_data.p_final);
end

% Reshape sensor data back into 3D volume
p_max = unmaskSensorData(kgrid, sensor, sensor_data.p_max);

% Render volume in figure window
labelvolshow(skullAndTransducer, p_max, 'VolumeThreshold', 0.075);
