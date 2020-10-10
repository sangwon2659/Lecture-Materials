classdef InvertedPendulumGUI_fixed_parameters_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        InvertedPendulumSimulationLabel  matlab.ui.control.Label
        SimulateButton            matlab.ui.control.Button
        ResponseGraphsPanel       matlab.ui.container.Panel
        UIAxes                    matlab.ui.control.UIAxes
        UIAxes_2                  matlab.ui.control.UIAxes
        DesiredradSpinnerLabel    matlab.ui.control.Label
        DesiredradSpinner         matlab.ui.control.Spinner
        ProportionalSpinnerLabel  matlab.ui.control.Label
        ProportionalSpinner       matlab.ui.control.Spinner
        IntegralSpinnerLabel      matlab.ui.control.Label
        IntegralSpinner           matlab.ui.control.Spinner
        DerivativeSpinnerLabel    matlab.ui.control.Label
        DerivativeSpinner         matlab.ui.control.Spinner
        MassofCart05kgLabel       matlab.ui.control.Label
        MassofPendulum02kgLabel   matlab.ui.control.Label
        LengthofPendulum06mLabel  matlab.ui.control.Label
        Image                     matlab.ui.control.Image
    end

    
    properties (Access = public)
        Property % Description
        Desired
        P
        I
        D
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: DesiredradSpinner
        function DesiredradSpinnerValueChanged(app, event)
            Desired = app.DesiredradSpinner.Value;
        end

        % Value changed function: ProportionalSpinner
        function ProportionalSpinnerValueChanged(app, event)
            P = app.ProportionalSpinner.Value;
        end

        % Value changed function: IntegralSpinner
        function IntegralSpinnerValueChanged(app, event)
            I = app.IntegralSpinner.Value;
        end

        % Value changed function: DerivativeSpinner
        function DerivativeSpinnerValueChanged(app, event)
            D = app.DerivativeSpinner.Value;
        end

        % Button pushed function: SimulateButton
        function SimulateButtonPushed(app, event)
            close all;
            % Calling the values of the variables
            time_ = 0:1:9;
            data = zeros(10);
            plot(app.UIAxes,time_,data);
            plot(app.UIAxes_2,time_,data);
            Desired = app.DesiredradSpinner.Value;
            P = app.ProportionalSpinner.Value;
            I = app.IntegralSpinner.Value;
            D = app.DerivativeSpinner.Value;
            % Sending the variables to the workspace for simulink operations
            assignin("base","Desired",Desired)
            assignin("base","P",P)
            assignin("base","I",I)
            assignin("base","D",D)
            Simulation = sim('InvertedPendulumSimulation.slx');
            % time -> x variable for time
            time = Simulation.get('tout');
            % Getting angle data from the simulation
            q = Simulation.get('q');
            % Converting the time series data to array for plotting
            q = q.Data;
            % Getting the cart position data from the simulation
            x = Simulation.get('x');
            % Converting the time series data to array for plotting
            x = x.Data;
            % Plotting the data to the two graphs
            plot(app.UIAxes,time,q());
            plot(app.UIAxes_2,time,x);
                        
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 850 600];
            app.UIFigure.Name = 'UI Figure';

            % Create InvertedPendulumSimulationLabel
            app.InvertedPendulumSimulationLabel = uilabel(app.UIFigure);
            app.InvertedPendulumSimulationLabel.FontSize = 36;
            app.InvertedPendulumSimulationLabel.Position = [153 544 495 45];
            app.InvertedPendulumSimulationLabel.Text = 'Inverted Pendulum Simulation';

            % Create SimulateButton
            app.SimulateButton = uibutton(app.UIFigure, 'push');
            app.SimulateButton.ButtonPushedFcn = createCallbackFcn(app, @SimulateButtonPushed, true);
            app.SimulateButton.FontSize = 20;
            app.SimulateButton.Position = [730 18 100 31];
            app.SimulateButton.Text = 'Simulate';

            % Create ResponseGraphsPanel
            app.ResponseGraphsPanel = uipanel(app.UIFigure);
            app.ResponseGraphsPanel.Title = 'Response Graphs';
            app.ResponseGraphsPanel.Position = [19 240 814 282];

            % Create UIAxes
            app.UIAxes = uiaxes(app.ResponseGraphsPanel);
            title(app.UIAxes, 'Pendulum Angle')
            xlabel(app.UIAxes, 'time (s)')
            ylabel(app.UIAxes, 'Angle (rad) [CCW -> +]')
            app.UIAxes.TitleFontWeight = 'bold';
            app.UIAxes.Position = [4 8 393 236];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.ResponseGraphsPanel);
            title(app.UIAxes_2, 'Cart Position')
            xlabel(app.UIAxes_2, 'time (s)')
            ylabel(app.UIAxes_2, 'Position (m) [Right -> +]')
            app.UIAxes_2.TitleFontWeight = 'bold';
            app.UIAxes_2.Position = [418 6 393 241];

            % Create DesiredradSpinnerLabel
            app.DesiredradSpinnerLabel = uilabel(app.UIFigure);
            app.DesiredradSpinnerLabel.HorizontalAlignment = 'right';
            app.DesiredradSpinnerLabel.FontSize = 20;
            app.DesiredradSpinnerLabel.Position = [593 202 122 24];
            app.DesiredradSpinnerLabel.Text = 'Desired (rad)';

            % Create DesiredradSpinner
            app.DesiredradSpinner = uispinner(app.UIFigure);
            app.DesiredradSpinner.ValueChangedFcn = createCallbackFcn(app, @DesiredradSpinnerValueChanged, true);
            app.DesiredradSpinner.FontSize = 20;
            app.DesiredradSpinner.Position = [730 201 100 25];

            % Create ProportionalSpinnerLabel
            app.ProportionalSpinnerLabel = uilabel(app.UIFigure);
            app.ProportionalSpinnerLabel.HorizontalAlignment = 'right';
            app.ProportionalSpinnerLabel.FontSize = 20;
            app.ProportionalSpinnerLabel.Position = [602 146 113 24];
            app.ProportionalSpinnerLabel.Text = 'Proportional';

            % Create ProportionalSpinner
            app.ProportionalSpinner = uispinner(app.UIFigure);
            app.ProportionalSpinner.ValueChangedFcn = createCallbackFcn(app, @ProportionalSpinnerValueChanged, true);
            app.ProportionalSpinner.FontSize = 20;
            app.ProportionalSpinner.Position = [730 145 100 25];

            % Create IntegralSpinnerLabel
            app.IntegralSpinnerLabel = uilabel(app.UIFigure);
            app.IntegralSpinnerLabel.HorizontalAlignment = 'right';
            app.IntegralSpinnerLabel.FontSize = 20;
            app.IntegralSpinnerLabel.Position = [643 109 72 24];
            app.IntegralSpinnerLabel.Text = 'Integral';

            % Create IntegralSpinner
            app.IntegralSpinner = uispinner(app.UIFigure);
            app.IntegralSpinner.ValueChangedFcn = createCallbackFcn(app, @IntegralSpinnerValueChanged, true);
            app.IntegralSpinner.FontSize = 20;
            app.IntegralSpinner.Position = [730 108 100 25];

            % Create DerivativeSpinnerLabel
            app.DerivativeSpinnerLabel = uilabel(app.UIFigure);
            app.DerivativeSpinnerLabel.HorizontalAlignment = 'right';
            app.DerivativeSpinnerLabel.FontSize = 20;
            app.DerivativeSpinnerLabel.Position = [621 73 94 24];
            app.DerivativeSpinnerLabel.Text = 'Derivative';

            % Create DerivativeSpinner
            app.DerivativeSpinner = uispinner(app.UIFigure);
            app.DerivativeSpinner.ValueChangedFcn = createCallbackFcn(app, @DerivativeSpinnerValueChanged, true);
            app.DerivativeSpinner.FontSize = 20;
            app.DerivativeSpinner.Position = [730 72 100 25];

            % Create MassofCart05kgLabel
            app.MassofCart05kgLabel = uilabel(app.UIFigure);
            app.MassofCart05kgLabel.FontSize = 16;
            app.MassofCart05kgLabel.Position = [240 190 154 22];
            app.MassofCart05kgLabel.Text = 'Mass of Cart = 0.5kg';

            % Create MassofPendulum02kgLabel
            app.MassofPendulum02kgLabel = uilabel(app.UIFigure);
            app.MassofPendulum02kgLabel.FontSize = 16;
            app.MassofPendulum02kgLabel.Position = [240 152 196 22];
            app.MassofPendulum02kgLabel.Text = 'Mass of Pendulum = 0.2kg';

            % Create LengthofPendulum06mLabel
            app.LengthofPendulum06mLabel = uilabel(app.UIFigure);
            app.LengthofPendulum06mLabel.FontSize = 16;
            app.LengthofPendulum06mLabel.Position = [240 115 204 22];
            app.LengthofPendulum06mLabel.Text = 'Length of Pendulum = 0.6m';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [23 18 204 204];
            app.Image.ImageSource = 'Inverted Pendulum.png';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = InvertedPendulumGUI_fixed_parameters_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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