classdef UI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        GridLayout                matlab.ui.container.GridLayout
        LoadingImage              matlab.ui.control.Image
        Image                     matlab.ui.control.Image
        Image2                    matlab.ui.control.Image
        Image3                    matlab.ui.control.Image
        Image4                    matlab.ui.control.Image
        BrighntessAdjustmentImage matlab.ui.control.Image
        BrightnessTrackingButton  matlab.ui.control.Button
        HighlightTrackingButton   matlab.ui.control.Button
        BackButton                matlab.ui.control.Button
        UploadFileButton          matlab.ui.control.Button
        ExportPlotButton          matlab.ui.control.Button
        StartButton               matlab.ui.control.Button
        CellTrackingbasedonTIFFstackLabel  matlab.ui.control.Label
        HenningLabel            matlab.ui.control.Label
        ErrorLabel              matlab.ui.control.Label
        BrightnessLabel         matlab.ui.control.Label
        LoadingLabel            matlab.ui.control.Label
        TextArea                matlab.ui.control.TextArea
        UIAxes                  matlab.ui.control.UIAxes
        ProgressBar             matlab.ui.container.Panel
        Slider                  matlab.ui.control.Slider
        processing = false;
        tiffName
        tiffInfo
        stackSize
        tiffStack = [];
        imageHeight
        imageWidth
        videoName
        brightnessValue
        ph
        th
    end

    % Functions for UI Rendering
    methods (Access = private)
        function toogleVisibility(app, state)
            app.Image4.Visible = state;
            app.Image3.Visible = state;
            app.Image2.Visible = state;
            app.TextArea.Visible = state;
        end

        function loadFirstScreen(app)
            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));
            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'fit', '0.1x', '0.1x', '0.1x', '0.1x', '0.03x', '0.1x', '0.4x'};

            % Create CellTrackingbasedonTIFFstackLabel
            app.CellTrackingbasedonTIFFstackLabel = uilabel(app.GridLayout);
            app.CellTrackingbasedonTIFFstackLabel.BackgroundColor = [0 0.4471 0.7412];
            app.CellTrackingbasedonTIFFstackLabel.HorizontalAlignment = 'center';
            app.CellTrackingbasedonTIFFstackLabel.FontSize = 24;
            app.CellTrackingbasedonTIFFstackLabel.FontWeight = 'bold';
            app.CellTrackingbasedonTIFFstackLabel.FontColor = [1 1 1];
            app.CellTrackingbasedonTIFFstackLabel.Layout.Row = 1;
            app.CellTrackingbasedonTIFFstackLabel.Layout.Column = [1 3];
            app.CellTrackingbasedonTIFFstackLabel.Text = 'Cell Tracking based on TIFF stack';

            % Create UploadFileButton
            app.UploadFileButton = uibutton(app.GridLayout, 'push');
            app.UploadFileButton.ButtonPushedFcn = createCallbackFcn(app, @UploadButtonPushed, true);
            app.UploadFileButton.Icon = 'Icon_upload.png';
            app.UploadFileButton.BackgroundColor = [0.0745 0.6235 1];
            app.UploadFileButton.FontSize = 18;
            app.UploadFileButton.FontWeight = 'bold';
            app.UploadFileButton.FontColor = [1 1 1];
            app.UploadFileButton.Layout.Row = 3;
            app.UploadFileButton.Layout.Column = 2;
            app.UploadFileButton.Text = 'Upload File';

            % Create Image
            app.LoadingImage = uiimage(app.GridLayout);
            app.LoadingImage.Layout.Row = 4;
            app.LoadingImage.Layout.Column = 2;
            app.LoadingImage.ImageSource = fullfile(pathToMLAPP, 'loading.gif');
            app.LoadingImage.Visible = 'off';
        end

        function loadSecondScreen(app)
            app.Slider.delete();
            app.BrightnessTrackingButton.delete();
            app.UploadFileButton.delete();
            app.HighlightTrackingButton.delete();

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'0.5x', '1x', '1x'};
            app.GridLayout.RowHeight = {0, 'fit', '0.15x', '1x', '1x', 'fit'};
            app.GridLayout.BackgroundColor = [0.8 0.8 0.8];

            % Create CellTrackingbasedonTIFFstackLabel
            app.CellTrackingbasedonTIFFstackLabel = uilabel(app.GridLayout);
            app.CellTrackingbasedonTIFFstackLabel.BackgroundColor = [0 0.4471 0.7412];
            app.CellTrackingbasedonTIFFstackLabel.HorizontalAlignment = 'center';
            app.CellTrackingbasedonTIFFstackLabel.FontSize = 24;
            app.CellTrackingbasedonTIFFstackLabel.FontWeight = 'bold';
            app.CellTrackingbasedonTIFFstackLabel.FontColor = [1 1 1];
            app.CellTrackingbasedonTIFFstackLabel.Layout.Row = 2;
            app.CellTrackingbasedonTIFFstackLabel.Layout.Column = [1 3];
            app.CellTrackingbasedonTIFFstackLabel.Text = 'Cell Tracking based on TIFF stack';

            % Create Image
            app.Image = uiimage(app.GridLayout);
            app.Image.Layout.Row = 4;
            app.Image.Layout.Column = 3;

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout);
            app.UIAxes.Layout.Row = 5;
            app.UIAxes.Layout.Column = 3;
            %             title(app.UIAxes, 'Title')
            %             xlabel(app.UIAxes, 'X')
            %             ylabel(app.UIAxes, 'Y')
            %             zlabel(app.UIAxes, 'Z')

            % Create Image3
            app.Image3 = uiimage(app.GridLayout);
            app.Image3.Layout.Row = 4;
            app.Image3.Layout.Column = 2;

            % Create Image4
            app.Image4 = uiimage(app.GridLayout);
            app.Image4.Layout.Row = 5;
            app.Image4.Layout.Column = 2;

            % Create HenningLabel
            app.HenningLabel = uilabel(app.GridLayout);
            app.HenningLabel.HorizontalAlignment = 'right';
            app.HenningLabel.Layout.Row = 6;
            app.HenningLabel.Layout.Column = 3;
            app.HenningLabel.Text = '© Henning Weise';

            % Create TextArea
            app.TextArea = uitextarea(app.GridLayout);
            app.TextArea.Layout.Row = [4 5];
            app.TextArea.Layout.Column = 1;
            app.TextArea.FontSize = 16;
            app.TextArea.Value{1} = sprintf('Name of Tiff: \t %s', app.tiffName);
            app.TextArea.Value{2} = '';
            app.TextArea.Value{3} = sprintf('Number of Images:\t %d', app.stackSize);
            app.TextArea.Value{4} = sprintf('Image Height: \t %d px', app.imageHeight);
            app.TextArea.Value{5} = sprintf('Image Width: \t %d px', app.imageWidth);

            % Create Loading
            app.LoadingImage = uiimage(app.GridLayout);
            app.LoadingImage.Layout.Row = 3;
            app.LoadingImage.Layout.Column = 3;
            app.LoadingImage.ImageSource = fullfile(pathToMLAPP, 'loading.gif');

            % Create BackButton
            app.BackButton = uibutton(app.GridLayout, 'push');
            app.BackButton.ButtonPushedFcn = createCallbackFcn(app, @GoBackButtonPushed, true);
            app.BackButton.Icon = 'Icon_back.png';
            app.BackButton.BackgroundColor = [0.0745 0.6235 1];
            app.BackButton.FontSize = 18;
            app.BackButton.FontWeight = 'bold';
            app.BackButton.FontColor = [1 1 1];
            app.BackButton.Layout.Row = 3;
            app.BackButton.Layout.Column = 1;
            app.BackButton.Text = 'Go Back';
            fprintf('Second Screen Loaded');

            % Create Progress Bar
            app.ProgressBar = uipanel(app.GridLayout);
            app.ProgressBar.Layout.Row = 3;
            app.ProgressBar.Layout.Column = 2;
            app.ProgressBar.AutoResizeChildren = 'off';
            ax = subplot(1,1,1,'Parent',app.ProgressBar);
            ax.Position = [.1 .4 .8 .2];
            ax.Box = 'on';
            ax.XTick = [];
            ax.YTick = [];
            ax.Color = [0.9375 0.9375 0.9375];
            ax.XAxis.Limits = [0,1];
            ax.YAxis.Limits = [0,1];
            title(ax,'Progress')
            % Create empty patch that will be updated
            app.ph = patch(ax,[0 0 0 0],[0 0 1 1],[0.67578 1 0.18359]); %greenyellow
            % Create the percent-complete text that will be updated
            app.th = text(ax,1,1,'0%','VerticalAlignment','bottom','HorizontalAlignment','right');
        end

        function loadTrackingButtons(app)
            % Create HighlightTrackingButton
            app.HighlightTrackingButton = uibutton(app.GridLayout, 'push');
            app.HighlightTrackingButton.ButtonPushedFcn = createCallbackFcn(app, @HighlightTrackingButtonPushed, true);
            app.HighlightTrackingButton.BackgroundColor = [0.0745 0.6235 1];
            app.HighlightTrackingButton.FontSize = 18;
            app.HighlightTrackingButton.FontWeight = 'bold';
            app.HighlightTrackingButton.FontColor = [1 1 1];
            app.HighlightTrackingButton.Layout.Row = 5;
            app.HighlightTrackingButton.Layout.Column = 2;
            app.HighlightTrackingButton.Text = 'Highlight Tracking';

            % Create BrightnessTrackingButton
            app.BrightnessTrackingButton = uibutton(app.GridLayout, 'push');
            app.BrightnessTrackingButton.ButtonPushedFcn = createCallbackFcn(app, @BrightnessTrackingButtonPushed, true);
            app.BrightnessTrackingButton.BackgroundColor = [0.0745 0.6235 1];
            app.BrightnessTrackingButton.FontSize = 18;
            app.BrightnessTrackingButton.FontWeight = 'bold';
            app.BrightnessTrackingButton.FontColor = [1 1 1];
            app.BrightnessTrackingButton.Layout.Row = 7;
            app.BrightnessTrackingButton.Layout.Column = 2;
            app.BrightnessTrackingButton.Text = 'Brightness Tracking';
        end

        function loadExportPlotButton(app)
            app.ExportPlotButton = uibutton(app.GridLayout, 'push');
            app.ExportPlotButton.ButtonPushedFcn = createCallbackFcn(app, @ExportPlotButtonPushed, true);
            app.ExportPlotButton.BackgroundColor = [0.0745 0.6235 1];
            app.ExportPlotButton.FontSize = 18;
            app.ExportPlotButton.FontWeight = 'bold';
            app.ExportPlotButton.FontColor = [1 1 1];
            app.ExportPlotButton.Layout.Row = 3;
            app.ExportPlotButton.Layout.Column = 3;
            app.ExportPlotButton.Text = 'Save Plot';
        end

        function setAxis(app)
            hold(app.UIAxes, 'on')
            xlabel(app.UIAxes, 'µm');
            ylabel(app.UIAxes, 'µm');
            % multiply x-axis values
            our_plot = app.UIAxes;
            xTickLabels = our_plot.XAxis.TickLabels;
            xLabels=zeros(1,length(xTickLabels)); % preallocate
            for k=1:length(xTickLabels)
                test = str2num(xTickLabels{k});
                xLabels(k)=test;
            end
            xLabels = xLabels/2.117;
            xValues = our_plot.XAxis.TickValues;
            xticklabels(app.UIAxes, xLabels)
            xticks(app.UIAxes,xValues);

            % multiply y-axis values
            yTickLabels = our_plot.YAxis.TickLabels;
            yLabels=zeros(1,length(yTickLabels)); % preallocate
            for k=1:length(yTickLabels)
                test = str2num(yTickLabels{k});
                yLabels(k)=test;
            end
            yLabels = yLabels/2.117;
            yValues = our_plot.YAxis.TickValues;
            yticklabels(app.UIAxes, yLabels)
            yticks(app.UIAxes,yValues);
        end

        function loadBrightnessAdjustment(app)
            app.BrightnessTrackingButton.delete();
            app.UploadFileButton.delete();
            app.HighlightTrackingButton.delete();

            % Create Slider
            app.Slider = uislider(app.GridLayout);
            app.Slider.Limits = [1 10];
            app.Slider.MajorTicks = [1 2 3 4 5 6 7 8 9 10];
            app.Slider.MajorTickLabels = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'};
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider.MinorTicks = [];
            app.Slider.Layout.Row = 3;
            app.Slider.Layout.Column = 2;
            app.Slider.Value = 4;

            app.BrightnessLabel = uilabel(app.GridLayout);
            app.BrightnessLabel.HorizontalAlignment = 'center';
            app.BrightnessLabel.Layout.Row = 2;
            app.BrightnessLabel.Layout.Column = 2;
            app.BrightnessLabel.FontSize = 16;
            app.BrightnessLabel.Text = 'Set Brightness, that tracking Object is good visible';

            app.UIAxes = uiaxes(app.GridLayout);
            app.UIAxes.Layout.Row = [4 6];
            app.UIAxes.Layout.Column = [1 3];
            image = imread(app.tiffName, 1);
            imshow(image, 'Parent', app.UIAxes);

            app.StartButton = uibutton(app.GridLayout, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.BackgroundColor = [0.0745 0.6235 1];
            app.StartButton.FontSize = 16;
            app.StartButton.FontWeight = 'bold';
            app.StartButton.FontColor = [1 1 1];
            app.StartButton.Layout.Row = 7;
            app.StartButton.Layout.Column = 2;
            app.StartButton.Text = 'Start Tracking';
        end
    end

    %Logical Functions
    methods (Access = private)
        % Method to create video from tiff stack
        function renderVideo(app)
            % Check if video file already exists
            if isfile(app.videoName)
                fprintf('File exists already \n')
            else
                fprintf('Create video file \n')
                videoWriter = VideoWriter(app.videoName);
                videoWriter.Quality = 100;
                open(videoWriter);
                % get frames
                mov(numel(app.tiffInfo)) = struct('cdata',[],'colormap',[]);
                for i=1:numel(app.tiffInfo)
                    I = imread(app.tiffName,i);
                    writeVideo(videoWriter, I);
                end
                % create video
                close(videoWriter);
            end
        end

        function updateProgressBar(app, imageNumber)
            n = app.stackSize;
            app.ph.XData = [0 imageNumber/n imageNumber/n 0];
            app.th.String = sprintf('%.0f%%',round(imageNumber/n*100));
            drawnow %update graphics
        end

        function brightnessTracking(app)
            fprintf('Start tracking brightness');
            app.processing = true;

            readTiffStack(app);

            % read first frame and set initial tracking rectangle
            objectFrame = imread(app.tiffName,1);
            figure;
            imshow(objectFrame);
            title('Mark object of interest!');
            roi = drawrectangle('Label','Tracked Object');
            binaryImage = createMask(roi);
            objectRegion = roi.Position;
            close;

            % Mask image, that only selected rectangle contains content
            % and everything outside is black
            grayImage = imbinarize(objectFrame, app.brightnessValue);
            blackMaskedImage = grayImage;
            blackMaskedImage(~binaryImage) = 0;

            % show inital frame with a red bounding box
            objectImage = insertShape(objectFrame,'rectangle',objectRegion,'Color','red','LineWidth',5);
            app.Image3.ImageSource = objectImage;

            % detect interesting points in the region
            props = regionprops(blackMaskedImage,'Centroid');
            centroids = cat(1,props.Centroid);
            sizeX = max(centroids(:,1)) - min(centroids(:,1));
            sizeY = max(centroids(:,2)) - min(centroids(:,2));
            app.TextArea.Value{6} = ' ';
            app.TextArea.Value{7} = sprintf('Length of object: \t %.2f µm', sizeX/2.117);
            app.TextArea.Value{8} = sprintf('Height of object: \t %.2f µm', sizeY/2.117);
            fprintf('TEST %.0f',sizeX);

            % display detected points
            pointImage = insertMarker(objectFrame,centroids,'+','Color','red','Size',5);
            app.Image.ImageSource = pointImage;

            % create Tracker object
            tracker = vision.PointTracker('MaxBidirectionalError',90);
            initialize(tracker,centroids,objectFrame);

            % create video
            v1 = VideoWriter('tracked.avi');
            v1.Quality = 100;
            open(v1);

           
            app.TextArea.Value{9} = ' ';

            % read, track, display points and results in each frame
            i = 1;
            while i <= app.stackSize && app.processing
                updateProgressBar(app, i);
                frame = app.tiffStack(:,:,i);
                [centroids,validity] = tracker(frame);
                pointsCleared = rmoutliers(centroids(validity, :),1);
                average = mean(pointsCleared);
                app.TextArea.Value{10} = sprintf('Position X: \t %.2f µm', average(:,1)/2.117);
                app.TextArea.Value{11} = sprintf('Position Y: \t %.2f µm', average(:,2)/2.117);
                if (i==1)
                    finalPoint = [];
                end
                finalPoint = cat(1, finalPoint, pointsCleared);
                finalPoint = mean(finalPoint);
                finalPoints(i,:) = finalPoint;
                out = insertMarker(frame,finalPoint,'*', 'Color','green', 'size', 40);
                writeVideo(v1, out);
                app.Image4.ImageSource = out;
                i = i+1;
            end
            close(v1);
            if (app.processing)
                imshow(app.tiffStack(:,:,1), 'Parent', app.UIAxes)
                hold(app.UIAxes, 'on')
                axis(app.UIAxes, 'on', 'image');
                plot(app.UIAxes,finalPoints(:,1), finalPoints(:,2), 'r--x', 'LineWidth', 1, 'MarkerSize', 1);
                setAxis(app);
                trackingFinished(app);
            end
        end

        function featureTracking(app)
            fprintf('Start tracking Feature');
            app.processing = true;

            readTiffStack(app);

            % read first frame and set initial tracking rectangle
            objectFrame = imread(app.tiffName,1);
            figure;
            imshow(objectFrame);
            title('Mark object of interest!');
            roi = drawrectangle('Label','Tracked Object');
            objectRegion = roi.Position;
            close;

            % show inital frame with a red bounding box
            objectImage = insertShape(objectFrame,'rectangle',objectRegion,'Color','red','LineWidth',5);
            app.Image3.ImageSource = objectImage;

            % detect interesting points in the region
            points = detectMinEigenFeatures(im2bw(objectFrame, 0.4),'ROI',objectRegion);

            % display detected points
            pointImage = insertMarker(objectFrame,points.Location,'+','Color','white');
            app.Image.ImageSource = pointImage;

            % create Tracker object
            tracker = vision.PointTracker('MaxBidirectionalError',3);
            initialize(tracker,points.Location,objectFrame);

            v1 = VideoWriter('tracked.avi');
            v1.Quality = 100;
            open(v1);

            LogicalStr = {'false', 'true'};
            % read, track, display points and results in each frame
            i = 1;
            while i <= app.stackSize && app.processing
                fprintf('Number: %d | %s\n', i, LogicalStr{app.processing + 1})
                updateProgressBar(app, i);
                frame = app.tiffStack(:,:,i);
                [points,validity] = tracker(frame);
                out = insertMarker(frame,points(validity, :),'+');
                writeVideo(v1, out);
                app.Image4.ImageSource = out;
                i = i+1;
            end
            close(v1);
            if (app.processing)
                imshow(app.tiffStack(:,:,1), 'Parent', app.UIAxes)
                hold(app.UIAxes, 'on')
                %axis('on', 'image');
                plot(app.UIAxes,points(:,1), points(:,2), 'o', 'LineWidth', 1, 'MarkerSize', 1);
                trackingFinished(app);
            end
        end

        function createVideo(app)
            app.videoName= strcat(app.tiffName, '.avi');
            % Check if video file already exists
            if isfile(app.videoName)
                fprintf('File exists already \n')
            else
                fprintf('Create video file \n')
                % get frames
                for i=1:numel(info)
                    imshow(imread(app.tiffName,i))
                    mov(i)=getframe(gca);
                end
                % create video
                videoWriter = VideoWriter(app.videoName);
                videoWriter.Quality = 100;
                open(videoWriter);
                writeVideo(videoWriter, mov);
                close(videoWriter);
            end
        end

        function handleError(app, ERROR)
            app.ErrorLabel = uilabel(app.GridLayout);
            app.ErrorLabel.HorizontalAlignment = 'center';
            app.ErrorLabel.FontSize = 16;
            app.ErrorLabel.FontColor = 'red';
            app.ErrorLabel.Layout.Row = 3;
            app.ErrorLabel.Layout.Column = 3;
            app.ErrorLabel.Text = sprintf('Some error occured while tracking: %s', ERROR.identifier);
        end

        function trackingFinished(app)
            app.LoadingImage.Visible = 'off';
            loadExportPlotButton(app);
            app.ProgressBar.delete();
            app.processing = false;
        end

        function readTiffStack(app)
            % Check if file is already loaded
            if (isempty(app.tiffStack))
                app.tiffStack = tiffreadVolume(app.tiffName);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'TIFF Cell Tracker';
            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % Callback functions
    methods (Access = private)
        % Code that executes after component creation
        function startupFcn(app)
            app.UIFigure.WindowState = 'maximized';
            loadFirstScreen(app);
        end

        function GoBackButtonPushed(app, event)
            app.processing = false;
            loadFirstScreen(app);
            loadTrackingButtons(app);
            app.ExportPlotButton.delete();
        end

        function UploadButtonPushed(app, event)
            app.tiffStack = [];
            app.LoadingImage.Visible = 'on';
            [file,path] = uigetfile('*.tiff');  %open a mat file
            app.tiffInfo = imfinfo(strcat(path, file));
            app.stackSize = numel(app.tiffInfo);
            app.imageHeight = app.tiffInfo.('Width');
            app.imageWidth = app.tiffInfo.('Height');
            app.tiffName = file;
            app.videoName = strcat(app.tiffName, '.avi');
            app.LoadingImage.Visible = 'off';
            loadTrackingButtons(app);
        end

        function StartButtonPushed(app, event)
            fprintf('Load second Screen');
            loadSecondScreen(app);
            pause(0.1)
            app.LoadingImage.Visible = 'on';
%             try
                brightnessTracking(app);
%             catch ERROR
%                 app.LoadingImage.Visible = 'off';
%                 handleError(app, ERROR);
%             end
        end

        function HighlightTrackingButtonPushed(app, event)
            loadSecondScreen(app);
            pause(0.1)
            app.LoadingImage.Visible = 'on';
            %             try
            featureTracking(app)
            %             catch ERROR
            %                 app.LoadingImage.Visible = 'off';
            %                 handleError(app, ERROR);
            %             end
        end

        function BrightnessTrackingButtonPushed(app, event)
            loadBrightnessAdjustment(app);
        end

        function SliderValueChanged(app, event)
            value = app.Slider.Value;
            app.brightnessValue = value/10;
            image = imbinarize(imread(app.tiffName, 1), app.brightnessValue);
            imshow(image, 'Parent', app.UIAxes)
        end

        function ExportPlotButtonPushed(app, event)
            % Create a temporary figure with axes.
            fig = figure;
            fig.Visible = 'off';
            figAxes = axes(fig);
            % Copy all UIAxes children, take over axes limits and aspect ratio.
            allChildren = app.UIAxes.XAxis.Parent.Children;
            copyobj(allChildren, figAxes)
            figAxes.XLim = app.UIAxes.XLim;
            figAxes.YLim = app.UIAxes.YLim;
            figAxes.DataAspectRatio = app.UIAxes.DataAspectRatio;

            % Save as png and fig files.
            saveas(fig, 'test', 'png');
            % Delete the temporary figure.
            delete(fig);
            app.ExportPlotButton.Visible = 'off';
            app.ErrorLabel = uilabel(app.GridLayout);
            app.ErrorLabel.HorizontalAlignment = 'center';
            app.ErrorLabel.FontSize = 16;
            app.ErrorLabel.FontColor = 'green';
            app.ErrorLabel.Layout.Row = 3;
            app.ErrorLabel.Layout.Column = 3;
            app.ErrorLabel.Text = sprintf('Plot successfully saved!');
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = UI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
