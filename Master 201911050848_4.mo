package Flaschenzug
  package Ports
    connector M_w
      flow Modelica.SIunits.Momentum M;
      Modelica.SIunits.Angle w;
      annotation(
        Icon(graphics = {Rectangle(origin = {-67, 86}, fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-33, 14}, {167, -186}}), Text(origin = {-49, 49}, extent = {{-9, 7}, {107, -97}}, textString = "M_w")}, coordinateSystem(initialScale = 0.1)));
    end M_w;

    connector F_s
      Modelica.SIunits.Position s;
      flow Modelica.SIunits.Force F;
      annotation(
        Icon(graphics = {Rectangle(origin = {-71, 90}, fillColor = {255, 193, 46}, fillPattern = FillPattern.Solid, extent = {{-29, 10}, {171, -190}}), Text(origin = {-109, 76}, extent = {{-9, 6}, {233, -132}}, textString = "F_s")}, coordinateSystem(initialScale = 0.1)),
        Diagram(coordinateSystem(initialScale = 0.1)));
    end F_s;

    connector U_i
      Real U;
      flow Real I;
      annotation(
        Icon(graphics = {Rectangle(fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 8}, extent = {{-70, 50}, {70, -50}}, textString = "U_i"), Rectangle(fillColor = {170, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-7, 4}, extent = {{-69, 38}, {69, -38}}, textString = "U_i")}, coordinateSystem(initialScale = 0.1)));
    end U_i;

    connector BoolIn = input Boolean "'Boolscher Input' as connector" annotation(
      Icon(graphics = {Polygon(fillColor = {79, 255, 15}, fillPattern = FillPattern.Solid, points = {{-100, 12}, {100, 100}, {100, -100}, {-100, -10}, {-100, -2}, {-100, 12}}), Text(origin = {-4, 9}, extent = {{-30, 39}, {74, -59}}, textString = "Bool_In")}, coordinateSystem(initialScale = 0.1)));
    connector BoolOut = output Boolean "'Boolscher Output' as connector" annotation(
      Icon(graphics = {Polygon(fillColor = {16, 255, 255}, fillPattern = FillPattern.Solid, points = {{-100, 12}, {100, 100}, {100, -100}, {-100, -10}, {-100, -2}, {-100, 12}}), Text(origin = {-4, 9}, extent = {{-30, 39}, {74, -59}}, textString = "Bool_Out")}, coordinateSystem(initialScale = 0.1)));
    annotation(
      Icon(graphics = {Rectangle(origin = {30, -30}, fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-130, 130}, {70, -70}}), Text(origin = {2, 3}, extent = {{-66, 33}, {66, -33}}, textString = "Ports")}));
  end Ports;

  package Modelle
    package Spannungsquellen
      model Spannung
        parameter Real U(unit "V") = 36 annotation(
          Dialog(group = "Elektrisch"));
        Real I(unit "A");
        //parameter Real t(unit "s") = 1;
        //Real t1;
        Flaschenzug.Ports.U_i u_i annotation(
          Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {124, -2}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
        Flaschenzug.Ports.BoolIn boolIn1 annotation(
          Placement(visible = true, transformation(origin = {148, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-130, -2.55351e-15}, extent = {{30, -30}, {-30, 30}}, rotation = 0)));
        Flaschenzug.Ports.BoolOut boolOut1 annotation(
          Placement(visible = true, transformation(origin = {-148, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-130, 64}, extent = {{-30, 30}, {30, -30}}, rotation = 0)));
      equation
        if U == 0 then
          0 = u_i.U;
          I = u_i.I;
          boolOut1 = true;
        elseif boolIn1 == true then
          0 = u_i.U;
          I = u_i.I;
          boolOut1 = true;
        else
          U = u_i.U;
          I = u_i.I;
          boolOut1 = false;
        end if;
        annotation(
          Diagram,
          Icon(graphics = {Ellipse(origin = {4, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Ellipse(origin = {-56, 61}, lineThickness = 1, extent = {{-22, 19}, {128, -127}}, endAngle = 360), Ellipse(origin = {66, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Rectangle(origin = {-10, 10}, lineThickness = 1, extent = {{-90, 90}, {110, -110}})}, coordinateSystem(initialScale = 0.1)));
      end Spannung;

      model Spannung_Zeitverlauf
        parameter Real U(unit "V") = 36;
        Real I(unit "A");
        parameter Real t(unit "s") = 1;
        Real t1;
        parameter Boolean KonstanteSpannung = false annotation(
          Dialog(group = "Betriebsarten"));
        Flaschenzug.Ports.U_i u_i annotation(
          Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {124, -2}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
        Flaschenzug.Ports.BoolIn boolIn1 annotation(
          Placement(visible = true, transformation(origin = {148, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-130, 6}, extent = {{30, -30}, {-30, 30}}, rotation = 0)));
        Flaschenzug.Ports.BoolOut boolOut1 annotation(
          Placement(visible = true, transformation(origin = {-148, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-130, 64}, extent = {{-30, 30}, {30, -30}}, rotation = 0)));
      equation
        if KonstanteSpannung == true then
          t1 = time * t;
          U = u_i.U;
          I = u_i.I;
          boolOut1 = false;
        else
          t1 = time * t;
          if t1 <= 3 then
            U = u_i.U;
            I = u_i.I;
            boolOut1 = false;
          elseif t1 > 3 and t1 <= 6 then
            u_i.U = 0;
            I = u_i.I;
            boolOut1 = true;
          elseif t1 > 6 and t1 <= 7.5 then
            12 = -u_i.U;
            I = u_i.I;
            boolOut1 = false;
          else
            u_i.U = 0;
            I = u_i.I;
            boolOut1 = true;
          end if;
        end if;
        annotation(
          Diagram,
          Icon(graphics = {Ellipse(origin = {4, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Ellipse(origin = {-56, 61}, lineThickness = 1, extent = {{-22, 19}, {128, -127}}, endAngle = 360), Ellipse(origin = {66, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Rectangle(origin = {-10, 10}, lineThickness = 1, extent = {{-90, 90}, {110, -110}})}, coordinateSystem(initialScale = 0.1)));
      end Spannung_Zeitverlauf;

      model Spannung_ohneBool
        parameter Real U(unit "V") = 36 annotation(
          Dialog(group = "Elektrisch"));
        Real I(unit "A");
        parameter Real t(unit "s") = 1 annotation(
          Dialog(group = "Betriebsarten"));
        Real t1;
        parameter Boolean KonstanteSpannung = false annotation(
          Dialog(group = "Betriebsarten"));
        Flaschenzug.Ports.U_i u_i annotation(
          Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {124, -2}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
      equation
        if KonstanteSpannung == true then
          t1 = time * t;
          U = u_i.U;
          I = u_i.I;
        else
          t1 = time * t;
          if t1 <= 3 then
            U = u_i.U;
            I = u_i.I;
          elseif t1 > 3 and t1 <= 6 then
            u_i.U = 0;
            I = u_i.I;
          elseif t1 > 9 and t1 <= 10 then
            u_i.U = 0;
            I = u_i.I;
          else
            U = -u_i.U;
            I = u_i.I;
          end if;
        end if;
        annotation(
          Diagram,
          Icon(graphics = {Ellipse(origin = {4, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Ellipse(origin = {-56, 61}, lineThickness = 1, extent = {{-22, 19}, {128, -127}}, endAngle = 360), Ellipse(origin = {66, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Rectangle(origin = {-10, 10}, lineThickness = 1, extent = {{-90, 90}, {110, -110}})}, coordinateSystem(initialScale = 0.1)));
      end Spannung_ohneBool;
      annotation(
        Icon(graphics = {Polygon(fillPattern = FillPattern.Solid, points = {{0, 100}, {-100, -100}, {100, -100}, {100, -100}, {0, 100}}), Polygon(origin = {-1, -2}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{1, 92}, {-91, -94}, {93, -94}, {1, 92}}), Polygon(origin = {-4, -24}, fillPattern = FillPattern.Solid, points = {{0, 64}, {-36, -20}, {8, 6}, {-10, -52}, {-2, -54}, {22, 22}, {-16, 0}, {24, 58}, {0, 64}, {0, 64}}), Polygon(origin = {-7, -77}, fillPattern = FillPattern.Solid, points = {{-13, 9}, {13, 3}, {-5, -9}, {-13, 9}})}));
    end Spannungsquellen;

    package Seilwinden
      model Seilwinde
        parameter Modelica.SIunits.Diameter Durchmesser = 0.2 "Trommeldurchmesser" annotation(
          Dialog(group = "Geometrie"));
        constant Real Pi = 2 * Modelica.Math.asin(1.0);
        parameter Modelica.SIunits.Momentum Lagerwiderstand = 0.0 "[Nm]" annotation(
          Dialog(group = "Trägheit und Verlust"));
        parameter Modelica.SIunits.Diameter d = 0.05 "Seildurchmesser [m]" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length b = 0.4 "Windenbreite [m]" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Mass m = 10 "Masse der Seilwinde excl. Seil" annotation(
          Dialog(group = "Trägheit und Verlust"));
        parameter Boolean Durchmesserkommulation = false annotation(
          Dialog(group = "Betriebsarten"));
        parameter Boolean Zugrichtug_aufwaerts = false annotation(
          Dialog(group = "Betriebsarten"));
        //(Dialog(group="Geometry"));
        //um Massenträgheit der Rolle zu Berechnen
        Real d_Winde;
        Integer v;
        Real o, dmax, s;
        Real J_Rolle, v_Rolle;
        //Massenträgheit der Rolle, Rotationsgeschwindigkeit der Rolle
        //Real d_Zusatz, Winkel;
        Flaschenzug.Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {58, 126}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {59, 119}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
        Flaschenzug.Ports.M_w m_w annotation(
          Placement(visible = true, transformation(origin = {-134, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-119, 1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
      equation
  if v - 1 >= 1 and Durchmesserkommulation == true then
///Berechnung des Windendurchmessers nicht als Step Funktion, sondern bisher als lineare Funktion
          d_Winde = Durchmesser + s * d;
          dmax = Durchmesser + (o - 1) * d * 2;
          s = (-m_w.w / (2 * Pi)) / (b / d) - 1;
        else
          d_Winde = Durchmesser;
          dmax = Durchmesser;
          s = 0;
        end if;
//Zurichtungsumkehr
        if Zugrichtug_aufwaerts == true then
          -f_s.F = (m_w.M - Lagerwiderstand) / (d_Winde / 2) - J_Rolle * der(v_Rolle);
        else
          f_s.F = (m_w.M - Lagerwiderstand) / (d_Winde / 2) - J_Rolle * der(v_Rolle);
        end if;
        v_Rolle = der(f_s.s);
//Drehgeschwindigkeit der Rolle
        J_Rolle = 0.5 * m * (Durchmesser / 2) ^ 2;
//Berechneung des Massenträgheits der Rolle unter Annahme eines massiven Zylinders.
        -v = floor(m_w.w / (2 * Pi) / (b / d));
        v = o;
//berechnet die Anzahl der Schichten +1
        f_s.s = Pi * d_Winde * (m_w.w / (2 * Pi));
//Kraftberechnung am Port, inklusive Massenträgheitsbetrachtung
//d_Zusatz-(Durchmesser*Winkel)=sum((((i/i)*((b/d)*2))/100)*(Winkel-((b/d)*2*Pi*i-1)) for i in 1:(v-1));
//Winkel= (m_w1.w/(2*Pi));
        annotation(
          choices(choice(redeclare lib2.Resistor Load(a = {2}) "..."), choice(redeclare Capacitor Load(L = 3) "...")),
          Icon(graphics = {Rectangle(origin = {-44, 25}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-56, 15}, {144, -65}}), Line(origin = {42.7034, 3.51}, points = {{18, 97}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-17.8189, 3.16671}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {1.89746, 1.88313}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {21.9273, 3.10701}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Rectangle(origin = {-92, -10}, fillPattern = FillPattern.Solid, extent = {{-9, 70}, {9, -70}}), Rectangle(origin = {92, -10}, fillPattern = FillPattern.Solid, extent = {{-9, 70}, {9, -70}}), Rectangle(origin = {-13, -61}, rotation = -90, fillPattern = FillPattern.Solid, extent = {{-9, 114}, {41, -88}})}, coordinateSystem(initialScale = 0.1)));
      end Seilwinde;

      model Seilwinde_Decke
        parameter Modelica.SIunits.Diameter Durchmesser = 0.2 "Trommeldurchmesser" annotation(
          Dialog(group = "Geometrie"));
        constant Real Pi = 2 * Modelica.Math.asin(1.0);
        parameter Modelica.SIunits.Momentum Lagerwiderstand = 0.0 "[Nm]" annotation(
          Dialog(group = "Trägheit und Verlust"));
        parameter Modelica.SIunits.Diameter d = 0.05 "Seildurchmesser [m]" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length b = 0.4 "Windenbreite [m]" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Mass m = 10 "Masse der Seilwinde excl. Seil" annotation(
          Dialog(group = "Trägheit und Verlust"));
        parameter Boolean Durchmesserkommulation = false annotation(
          Dialog(group = "Betriebsarten"));
        parameter Boolean Zugrichtug_aufwaerts = false annotation(
          Dialog(group = "Betriebsarten"));
        //(Dialog(group="Geometry"));
        //um Massenträgheit der Rolle zu Berechnen
        Real d_Winde;
        Integer v;
        Real o, dmax, s;
        Real J_Rolle, v_Rolle;
        //Massenträgheit der Rolle, Rotationsgeschwindigkeit der Rolle
        //Real d_Zusatz, Winkel;
        Flaschenzug.Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {58, 126}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {57, -117}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
        Flaschenzug.Ports.M_w m_w annotation(
          Placement(visible = true, transformation(origin = {-134, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-119, 5}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
      equation
  if v - 1 >= 1 and Durchmesserkommulation == true then
///Berechnung des Windendurchmessers nicht als Step Funktion, sondern bisher als lineare Funktion
          d_Winde = Durchmesser + s * d;
          dmax = Durchmesser + (o - 1) * d * 2;
          s = (-m_w.w / (2 * Pi)) / (b / d) - 1;
        else
          d_Winde = Durchmesser;
          dmax = Durchmesser;
          s = 0;
        end if;
//Zurichtungsumkehr
        if Zugrichtug_aufwaerts == true then
          -f_s.F = (m_w.M - Lagerwiderstand) / (d_Winde / 2) - J_Rolle * der(v_Rolle);
        else
          f_s.F = (m_w.M - Lagerwiderstand) / (d_Winde / 2) - J_Rolle * der(v_Rolle);
        end if;
        v_Rolle = der(f_s.s);
//Drehgeschwindigkeit der Rolle
        J_Rolle = 0.5 * m * (Durchmesser / 2) ^ 2;
//Berechneung des Massenträgheits der Rolle unter Annahme eines massiven Zylinders.
        -v = floor(m_w.w / (2 * Pi) / (b / d));
        v = o;
//berechnet die Anzahl der Schichten +1
        f_s.s = Pi * d_Winde * (m_w.w / (2 * Pi));
//Kraftberechnung am Port, inklusive Massenträgheitsbetrachtung
//d_Zusatz-(Durchmesser*Winkel)=sum((((i/i)*((b/d)*2))/100)*(Winkel-((b/d)*2*Pi*i-1)) for i in 1:(v-1));
//Winkel= (m_w1.w/(2*Pi));
        annotation(
          choices(choice(redeclare lib2.Resistor Load(a = {2}) "..."), choice(redeclare Capacitor Load(L = 3) "...")),
          Icon(graphics = {Rectangle(origin = {-44, 25}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-56, 15}, {144, -65}}), Line(origin = {38.3208, -57.8465}, points = {{18, 97}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-17.8189, 3.16671}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {1.89746, 1.88313}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {21.9273, 3.10701}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Rectangle(origin = {-92, 10}, fillPattern = FillPattern.Solid, extent = {{-9, 70}, {9, -70}}), Rectangle(origin = {92, 8}, fillPattern = FillPattern.Solid, extent = {{-9, 70}, {9, -70}}), Rectangle(origin = {-13, 91}, rotation = -90, fillPattern = FillPattern.Solid, extent = {{-9, 114}, {41, -88}})}, coordinateSystem(initialScale = 0.1)));
      end Seilwinde_Decke;
  annotation(
        Icon(graphics = {Rectangle(origin = {-1, -1}, fillColor = {140, 140, 140}, fillPattern = FillPattern.Solid, extent = {{-99, 41}, {101, -41}}), Line(origin = {-25.7439, -1.2561}, points = {{-22, 41}, {22, -41}, {22, -41}}, color = {213, 0, 0}, thickness = 3), Line(origin = {-2.42683, -0.475612}, points = {{-22, 41}, {22, -41}, {22, -41}}, color = {213, 0, 0}, thickness = 3), Line(origin = {23.4512, -0.463417}, points = {{-22, 41}, {22, -41}, {22, -41}}, color = {213, 0, 0}, thickness = 3), Line(origin = {36.2439, -0.731709}, points = {{20, 75}, {22, -41}, {22, -41}}, color = {213, 0, 0}, thickness = 3)}));
    end Seilwinden;

    package Flaschenzuege
      model Flaschenzug_Modell
        parameter Integer n = 3 "Anzahl der Rollen" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length s = 1 "Anfangslänge" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length Sa = 0.5 "Sensorabstand" annotation(
          Dialog(group = "Elektrisch"));
        parameter Modelica.SIunits.Angle Zugwinkel = 45 "Zugwinkel" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Mass Flaschengewicht_unten = 2 "[kg]" annotation(
          Dialog(group = "Trägheit und Verlust"));
        Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
        //Erdbeschleunigung
        Real v;
        //Geschwindigkeit der unteren Flasche
        Real Fges;
        //Flaschengewicht und Beschleunigungskraft
        Real Zwinkel;
        //Umrechnung Zugwinkel von Grad in Rad/s
        constant Real Pi = 2 * Modelica.Math.asin(1.0);
        Flaschenzug.Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {2, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {1, -115}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
        Flaschenzug.Ports.F_s f_s1 annotation(
          Placement(visible = true, transformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {1, 113}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
        Flaschenzug.Ports.F_s f_s2 annotation(
          Placement(visible = true, transformation(origin = {-114, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-114, -30}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
        Flaschenzug.Ports.BoolOut boolOut1 annotation(
          Placement(visible = true, transformation(origin = {-32, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-14, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      equation
  if f_s.s + Sa >= f_s1.s then
//Stoppen, wenn Flaschenzug ganz zusammengefahren
          boolOut1 = true;
        else
          boolOut1 = false;
        end if;
        Fges = f_s.F - Flaschengewicht_unten * g - Flaschengewicht_unten * der(v);
        f_s2.F = Fges / n;
//nur positive Seilräfte werden zugelassen
        v = der(f_s.s);
        Zwinkel = Zugwinkel * (180 / Pi);
        -f_s.s = (-f_s1.s) + s + f_s2.s / n;
        f_s1.F = f_s.F + cos(Zwinkel) * f_s2.F - Flaschengewicht_unten * g;
        annotation(
          Icon(graphics = {Rectangle(origin = {-3, -65}, fillPattern = FillPattern.Solid, extent = {{-1, 3}, {9, -35}}), Rectangle(origin = {-3, 69}, fillPattern = FillPattern.Solid, extent = {{-1, 31}, {9, -47}}), Line(origin = {-69.18, 25}, points = {{55, 42}, {-31, -56}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-21.89, -45.81}, points = {{11, 57}, {9, -37}}, color = {255, 85, 0}, thickness = 1), Line(origin = {21.8499, 44.31}, points = {{0, 9}, {-8, -127}}, color = {255, 85, 0}, thickness = 1), Line(origin = {43.12, -11.0249}, points = {{-31, 20}, {-41, -50}}, color = {255, 85, 0}, thickness = 1), Ellipse(origin = {2, 51}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-24, 23}, {20, -21}}, endAngle = 360), Ellipse(origin = {4, -84}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-18, 16}, {12, -14}}, endAngle = 360), Ellipse(origin = {1, 9}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-13, 15}, {13, -11}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body>Unterschied zum Flaschenzug_Modell:<br><br></body></html>"));
      end Flaschenzug_Modell;

      model Flaschenzug_Modell_b
        parameter Integer n = 3 "Anzahl der Rollen" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length s = 1 "Anfangslänge" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length Sa = 0.5 "Sensorabstand" annotation(
          Dialog(group = "Elektrisch"));
        parameter Modelica.SIunits.Angle Zugwinkel = 45 "Zugwinkel" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Mass Flaschengewicht_unten = 2 "[kg]" annotation(
          Dialog(group = "Trägheit und Verlust"));
        Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
        //Erdbeschleunigung
        Real v;
        //Geschwindigkeit der unteren Flasche
        Real Fges;
        //Flaschengewicht und Beschleunigungskraft
        Real Zwinkel;
        //Umrechnung Zugwinkel von Grad in Rad/s
        constant Real Pi = 2 * Modelica.Math.asin(1.0);
        Flaschenzug.Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {2, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {1, -115}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
        Flaschenzug.Ports.F_s f_s1 annotation(
          Placement(visible = true, transformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {1, 113}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
        Flaschenzug.Ports.F_s f_s2 annotation(
          Placement(visible = true, transformation(origin = {-114, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-114, 56}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
        Flaschenzug.Ports.BoolOut boolOut1 annotation(
          Placement(visible = true, transformation(origin = {-32, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {16, 86}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      equation
  if f_s.s + Sa >= f_s1.s then
//Stoppen, wenn Flaschenzug ganz zusammengefahren
          boolOut1 = true;
        else
          boolOut1 = false;
        end if;
        Fges = f_s.F - Flaschengewicht_unten * g - Flaschengewicht_unten * der(v);
        f_s2.F = Fges / (n - 1);
//nur positive Seilräfte werden zugelassen
        v = der(f_s.s);
        Zwinkel = Zugwinkel * (180 / Pi);
        -f_s.s = (-f_s1.s) + s + f_s2.s / (n - 1);
        f_s1.F = f_s.F + cos(Zwinkel) * f_s2.F - Flaschengewicht_unten * g;
        annotation(
          Icon(graphics = {Rectangle(origin = {-3, -65}, fillPattern = FillPattern.Solid, extent = {{-1, 39}, {9, -35}}), Rectangle(origin = {-3, 69}, fillPattern = FillPattern.Solid, extent = {{-1, 31}, {9, -31}}), Line(origin = {-68.89, 24.71}, points = {{55, -114}, {-31, 32}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-20.4565, 11.2428}, points = {{7, 45}, {9, -37}}, color = {255, 85, 0}, thickness = 1), Line(origin = {28.73, 52.62}, points = {{-14, 9}, {-8, -127}}, color = {255, 85, 0}, thickness = 1), Line(origin = {54.0145, 23.3787}, points = {{-53, 14}, {-41, -50}}, color = {255, 85, 0}, thickness = 1), Ellipse(origin = {2, -75}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-24, 23}, {20, -21}}, endAngle = 360), Ellipse(origin = {4, 56}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-18, 16}, {12, -14}}, endAngle = 360), Ellipse(origin = {1, -27}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-13, 15}, {13, -11}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body>s. Flaschenzugmodell<div><br></div><div>Unterschied zum Flaschenzug_Modell:<br>Die Anzahl der eingegebenen Tragenden Seile wird in den Formeln um 1 minimiert, um ein Festes Seilende an der oberen Flasche zu simulieren</div></body></html>"));
      end Flaschenzug_Modell_b;
    annotation(
        Icon(graphics = {Rectangle(origin = {-3, -65}, fillPattern = FillPattern.Solid, extent = {{-1, 3}, {9, -35}}), Rectangle(origin = {-3, 69}, fillPattern = FillPattern.Solid, extent = {{-1, 31}, {9, -47}}), Line(origin = {-69.18, 25}, points = {{55, 42}, {-31, -56}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-21.89, -45.81}, points = {{11, 57}, {9, -37}}, color = {255, 85, 0}, thickness = 1), Line(origin = {21.8499, 44.31}, points = {{0, 9}, {-8, -127}}, color = {255, 85, 0}, thickness = 1), Line(origin = {43.12, -11.0249}, points = {{-31, 20}, {-41, -50}}, color = {255, 85, 0}, thickness = 1), Ellipse(origin = {2, 51}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-24, 23}, {20, -21}}, endAngle = 360), Ellipse(origin = {4, -84}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-18, 16}, {12, -14}}, endAngle = 360), Ellipse(origin = {1, 9}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-13, 15}, {13, -11}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
        Documentation(info = "<html><head></head><body>Unterschied zum Flaschenzug_Modell:<br><br></body></html>"));
    end Flaschenzuege;

    package Massen
      model Masse
        parameter Modelica.SIunits.Mass m = 100 annotation(
          Dialog(group = "Masse"));
        //Masse
        Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
        //Erdbeschleunigung
        Real a, v;
        Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      equation
        f_s.F = m * g + m * a;
//Positive Kraft nach unten
        der(v) = a;
        der(f_s.s) = v;
        annotation(
          Icon(graphics = {Polygon(fillColor = {102, 102, 102}, fillPattern = FillPattern.Solid, points = {{-100, 60}, {-60, 100}, {60, 100}, {100, 60}, {100, -100}, {-100, -100}, {-100, -84}, {-100, 60}}), Text(origin = {-35, 33}, lineColor = {221, 221, 221}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid, extent = {{-27, 23}, {97, -77}}, textString = "Masse")}, coordinateSystem(initialScale = 0.1)));
      end Masse;

      model Bierkasten
        parameter Modelica.SIunits.Mass m = 100 annotation(
          Dialog(group = "Masse"));
        //Masse
        Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
        //Erdbeschleunigung
        Real a, v;
        Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      equation
        f_s.F = m * g + m * a;
//Positive Kraft nach unten
        der(v) = a;
        der(f_s.s) = v;
        annotation(
          Icon(graphics = {Rectangle(fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {3, 41}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-77, 19}, {77, -19}}), Text(origin = {6, -22}, lineColor = {255, 255, 255}, extent = {{-74, 18}, {74, -18}}, textString = "Chiemseer"), Rectangle(origin = {6, -38}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-70, 2}, {70, -2}}), Text(origin = {-20, -41}, lineColor = {255, 255, 255}, extent = {{-6, 5}, {54, -19}}, textString = "Rosenheimer"), Text(origin = {2, -63}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, extent = {{-60, 7}, {60, -7}}, textString = "Spezialbrauerei")}));
      end Bierkasten;
    annotation(
        Icon(graphics = {Polygon(fillColor = {102, 102, 102}, fillPattern = FillPattern.Solid, points = {{-100, 60}, {-60, 100}, {60, 100}, {100, 60}, {100, -100}, {-100, -100}, {-100, -84}, {-100, 60}}), Text(origin = {-35, 33}, lineColor = {221, 221, 221}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid, extent = {{-27, 23}, {97, -77}}, textString = "Masse")}, coordinateSystem(initialScale = 0.1)));
    end Massen;

    package Antriebskomponenten
      model Motor
        Flaschenzug.Ports.M_w m_w annotation(
          Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {124, 15}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
        constant Real Pi = Modelica.Constants.pi;
        // Bürstenspannungsabfall
        parameter Real Ub(unit = "V") = 0.4 annotation(
          Dialog(group = "Motorparameter"));
        // Ankerwiderstand
        parameter Real Ra(unit = "Ohm") = 0.608 annotation(
          Dialog(group = "Motorparameter"));
        // Ankerinduktivität
        parameter Real La(unit = "H") = 0.000423 annotation(
          Dialog(group = "Motorparameter"));
        // Gesamtes Massenträgheitsmoment
        parameter Real Jtot(unit = "kg.m2") = 0.018 annotation(
          Dialog(group = "Motorparameter"));
        // Drehmomentkonstante
        parameter Real kt(unit = "N.m/A") = 0.091534 annotation(
          Dialog(group = "Motorparameter"));
        // Reibungskonstante
        parameter Real cf(unit = "N.m.s") = 0.000000 annotation(
          Dialog(group = "Motorparameter"));
        // Ventilationskonstante
        parameter Real cv(unit = "N.m.s2") = 0.000005 annotation(
          Dialog(group = "Motorparameter"));
        // Drehzahl
        Real n(unit = "Hz");
        // Reibungsmoment
        Real Mf(unit = "N.m");
        // Ventilationsmoment
        Real Mv(unit = "N.m");
        // Ankerspannung
        Real Ua(unit = "V");
        // Ankerstrom
        Real Ia(unit = "A");
        // Winkelgeschwindigkeit
        Real w(unit = "rad/s");
        //Spannungskonstante
        Real ke(unit = "N.m/A ");
        //Luftspaltdrehmoment
        Real Me(unit = "N.m");
        //Leistung
        Real P(unit = "W");
        Flaschenzug.Ports.U_i u_i annotation(
          Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-75, 11}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
      equation
        u_i.U = Ua;
// Formeln Gleichstrommaschine mit Permanentmagneten
        Ia = u_i.I;
        Ua = 2 * Ub + Ra * Ia + La * der(Ia) + ke * n;
        Jtot * der(w) = Me - Mf - Mv - m_w.M;
        Me = kt * Ia;
        kt = ke / (2 * Pi);
        Mf = cf * n;
        Mv = sign(n) * cv * n ^ 2;
        w = 2 * Pi * n;
        der(m_w.w) = w;
        P = u_i.U * Ia;
        annotation(
          Icon(graphics = {Rectangle(origin = {-35, -17}, fillColor = {186, 186, 186}, fillPattern = FillPattern.Horizontal, lineThickness = 1, extent = {{-65, 117}, {135, -61}}), Polygon(origin = {0, -89}, fillPattern = FillPattern.Solid, points = {{-92, -11}, {92, -11}, {64, 11}, {-64, 11}, {-62, 11}, {-92, -11}}), Rectangle(origin = {-17, 53}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-22, 18}, {22, -18}}), Text(origin = {-17, 54}, lineColor = {255, 30, 33}, extent = {{-13, -6}, {13, 6}}, textString = "ABB")}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body><font size=\"4\">Der Motor ist eine Gleichstrommaschine mit Permanentmagneten und Grafitbürsten.</font><div><font size=\"4\">Die Bemessungsspannung beträgt U<sub>a rat&nbsp;</sub>= 48V<br></font><div><font size=\"4\"><br></font></div><div><font size=\"4\"><b>Auslegung des Motors:</b></font></div><div><span style=\"font-size: large;\">Moment an der Welle: M</span><sub>sh&nbsp;</sub><span style=\"font-size: large;\">= 0-8 Nm</span></div><div><font size=\"4\">Umdrehung pro min: n = 0-5000 min<sup>-1</sup></font></div><div><font size=\"4\"><br></font></div><div><font size=\"4\"><b>Parametrierbare Parameter in der Visualisierung</b></font></div><div><font size=\"4\">Bürstenspannungsabfall: 2<sub>Ub&nbsp;</sub>= 0.8&nbsp;V</font></div><div><font size=\"4\">Ankerwiderstand: R<sub>a </sub>=&nbsp;0.608&nbsp;Ohm</font></div><div><font size=\"4\">Ankerinduktivität: L<sub>a </sub>=&nbsp;423 µ</font><span style=\"font-size: large;\">H</span></div><div><font size=\"4\">Gesamtes Massenträgheitsmoment: J<sub>tot </sub>= 0.018&nbsp;kgm<sup>2</sup></font></div><div><font size=\"4\">Drehmomentkonstante: k<sub>t</sub>&nbsp;= 0.091534&nbsp;</font><span style=\"font-size: large;\">Nm/A</span></div>
<div><font size=\"4\">Reibungskonstante: C<sub>f</sub>&nbsp;= 0 Nms</font></div><div><font size=\"4\">Ventilationskonstante: C<sub>v</sub>&nbsp;= 0.000005 Nms<sup>2</sup></font></div></div></body></html>"));
      end Motor;

      model Getriebe
        parameter Real Uebersetzung = 3 "Übersetzung" annotation(
          Dialog(group = "Getriebeparameter"));
        parameter Modelica.SIunits.Efficiency Wirkungsgrad = 95 "Wirkungsgrad" annotation(
          Dialog(group = "Getriebeparameter"));
        parameter Modelica.SIunits.MomentOfInertia J_Eingangswelle = 0.05 annotation(
          Dialog(group = "Trägheiten"));
        parameter Modelica.SIunits.MomentOfInertia J_Ausgangsewelle = 0.05 annotation(
          Dialog(group = "Trägheiten"));
        Real v_w_ein;
        Real v_w_aus;
        Flaschenzug.Ports.M_w m_w annotation(
          Placement(visible = true, transformation(origin = {110, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {119, -29}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
        Flaschenzug.Ports.M_w m_w1 annotation(
          Placement(visible = true, transformation(origin = {-124, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
      equation
        m_w.M = m_w1.M * Uebersetzung * Wirkungsgrad - (v_w_aus * J_Ausgangsewelle - v_w_ein * J_Eingangswelle);
        -m_w.w = m_w1.w / Uebersetzung;
        v_w_ein = der(m_w1.w);
//Geschwindigkeit der Eingangswelle
        v_w_aus = der(m_w.w);
//Geschwindigkeit der Ausgangswelle
        annotation(
          Icon(graphics = {Rectangle(origin = {-77, 61}, lineColor = {70, 70, 70}, lineThickness = 4, extent = {{-23, 39}, {177, -159}}), Rectangle(origin = {91, -32}, fillColor = {52, 52, 52}, fillPattern = FillPattern.Solid, extent = {{-161, 10}, {11, -8}}), Rectangle(origin = {-75, 38}, fillColor = {52, 52, 52}, fillPattern = FillPattern.Solid, extent = {{-27, 6}, {119, -4}}), Rectangle(origin = {-9, 68}, fillColor = {159, 159, 159}, fillPattern = FillPattern.Forward, extent = {{-10, 7}, {20, -65}}), Rectangle(origin = {-19, -4}, fillColor = {106, 106, 106}, fillPattern = FillPattern.Forward, extent = {{-4, 7}, {34, -81}}), Rectangle(origin = {32, 59}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Rectangle(origin = {72, 58}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Ellipse(origin = {32, 56}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-82, 27}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-82, 24}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-42, 26}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {-82, 59}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-82, 56}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-42, 58}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-24, -6}}), Rectangle(origin = {-56, -7}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-56, -10}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-16, -8}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-24, -6}}), Rectangle(origin = {-56, -47}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-56, -50}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-16, -48}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {82, -47}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {82, -50}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {122, -48}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {82, -7}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {82, -10}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {122, -8}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {32, 27}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {32, 24}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {72, 26}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Text(origin = {-83, 84}, extent = {{-13, 10}, {13, -10}}, textString = "IN"), Text(origin = {79, -84}, extent = {{-13, 10}, {13, -10}}, textString = "OUT")}, coordinateSystem(initialScale = 0.1)),
          Dialog(group = "Getriebeparameter"));
      end Getriebe;

      model Bremse
        Flaschenzug.Ports.M_w m_w1 annotation(
          Placement(visible = true, transformation(origin = {-138, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-121, -9}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
        Flaschenzug.Ports.M_w m_w2 annotation(
          Placement(visible = true, transformation(origin = {112, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {121, -9}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
        Flaschenzug.Ports.BoolIn boolIn1 annotation(
          Placement(visible = true, transformation(origin = {-56, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-67, 57}, extent = {{27, -27}, {-27, 27}}, rotation = 0)));
        Real t = 1;
        Real t1;
        Real test;
        parameter Real b = 10000 annotation(
          Dialog(group = "Bremskonstante"));
        Real Bremsmoment;
      equation
        t1 = time * t;
/*if m_w1.w < m_w2.w then
  
      der(m_w2.w)=0;
      -m_w1.M =0;
      test= 0.5;
      Bremsmoment=0;*/
// Hier noch eine Funktion wenn die Spannung am Anfang auf 0 gestellt wird
        if boolIn1 == true and t1 > 0 then
// Funktioniert nur beim Hochziehen, bei einer Drehrichtung brauchen wir ne Fallunterscheidung
          Bremsmoment = b * der(m_w2.w);
          -m_w1.M = m_w2.M + Bremsmoment;
          m_w1.w = m_w2.w;
          test = 0;
        else
          Bremsmoment = 0;
          -m_w1.M = m_w2.M + Bremsmoment;
          m_w1.w = m_w2.w;
          test = 1;
        end if;
        annotation(
          Icon(graphics = {Rectangle(origin = {0, -8}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, extent = {{-100, 20}, {100, -22}}), Rectangle(origin = {-15, 154}, fillColor = {85, 85, 85}, fillPattern = FillPattern.Vertical, extent = {{-5, -54}, {35, -254}}), Polygon(origin = {32, 70}, fillColor = {200, 0, 0}, fillPattern = FillPattern.Solid, points = {{-10, 30}, {-10, -50}, {8, -50}, {8, 18}, {-10, 30}}), Polygon(origin = {-32, 70}, fillColor = {200, 0, 0}, fillPattern = FillPattern.Solid, points = {{10, 30}, {10, -50}, {-8, -50}, {-8, 18}, {10, 30}})}));
      end Bremse;
    annotation(
        Icon(graphics = {Rectangle(origin = {-35, -17}, fillColor = {186, 186, 186}, fillPattern = FillPattern.Horizontal, lineThickness = 1, extent = {{-65, 117}, {135, -61}}), Polygon(origin = {0, -89}, fillPattern = FillPattern.Solid, points = {{-92, -11}, {92, -11}, {64, 11}, {-64, 11}, {-62, 11}, {-92, -11}}), Rectangle(origin = {-17, 53}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-22, 18}, {22, -18}}), Text(origin = {-17, 54}, lineColor = {255, 30, 33}, extent = {{-13, -6}, {13, 6}}, textString = "ABB")}, coordinateSystem(initialScale = 0.1)),
        Documentation(info = "<html><head></head><body><font size=\"4\">Der Motor ist eine Gleichstrommaschine mit Permanentmagneten und Grafitbürsten.</font><div><font size=\"4\">Die Bemessungsspannung beträgt U<sub>a rat&nbsp;</sub>= 48V<br></font><div><font size=\"4\"><br></font></div><div><font size=\"4\"><b>Auslegung des Motors:</b></font></div><div><span style=\"font-size: large;\">Moment an der Welle: M</span><sub>sh&nbsp;</sub><span style=\"font-size: large;\">= 0-8 Nm</span></div><div><font size=\"4\">Umdrehung pro min: n = 0-5000 min<sup>-1</sup></font></div><div><font size=\"4\"><br></font></div><div><font size=\"4\"><b>Parametrierbare Parameter in der Visualisierung</b></font></div><div><font size=\"4\">Bürstenspannungsabfall: 2<sub>Ub&nbsp;</sub>= 0.8&nbsp;V</font></div><div><font size=\"4\">Ankerwiderstand: R<sub>a </sub>=&nbsp;0.608&nbsp;Ohm</font></div><div><font size=\"4\">Ankerinduktivität: L<sub>a </sub>=&nbsp;423 µ</font><span style=\"font-size: large;\">H</span></div><div><font size=\"4\">Gesamtes Massenträgheitsmoment: J<sub>tot </sub>= 0.018&nbsp;kgm<sup>2</sup></font></div><div><font size=\"4\">Drehmomentkonstante: k<sub>t</sub>&nbsp;= 0.091534&nbsp;</font><span style=\"font-size: large;\">Nm/A</span></div>
    <div><font size=\"4\">Reibungskonstante: C<sub>f</sub>&nbsp;= 0 Nms</font></div><div><font size=\"4\">Ventilationskonstante: C<sub>v</sub>&nbsp;= 0.000005 Nms<sup>2</sup></font></div></div></body></html>"));
    end Antriebskomponenten;

    package Gebaeude
      model Decke
        parameter Modelica.SIunits.Height Hoehe = 4 annotation(
          Dialog(group = "Höhe"));
        Flaschenzug.Ports.F_s f_s1 annotation(
          Placement(visible = true, transformation(origin = {6, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {3, -91}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      equation
        f_s1.s = Hoehe;
        annotation(
          Icon(graphics = {Rectangle(origin = {0, -74}, fillPattern = FillPattern.Solid, extent = {{-100, 2}, {100, -2}}), Line(origin = {-29.3731, -69.4329}, points = {{-5, -4}, {5, 4}}), Line(origin = {41.0299, -69.5523}, points = {{-5, -4}, {5, 4}}), Line(origin = {-80.7164, -69.6866}, points = {{-5, -4}, {5, 4}}), Line(origin = {55.4179, -69.2687}, points = {{-5, -4}, {5, 4}}), Line(origin = {-60.0597, -70.0299}, points = {{-5, -4}, {5, 4}}), Line(origin = {-3.38808, -69.7762}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {-49.7462, -69.7463}, points = {{-5, -4}, {5, 4}}), Line(origin = {-80.7164, -69.6866}, points = {{-5, -4}, {5, 4}}), Line(origin = {80.7463, -70.2687}, points = {{-5, -4}, {5, 4}}), Line(origin = {26.6418, -69.5225}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {11.6269, -69.4926}, points = {{-5, -4}, {5, 4}}), Line(origin = {-17.3283, -69.9254}, points = {{-5, -4}, {5, 4}}), Line(origin = {67.2985, -69.9254}, points = {{-5, -4}, {5, 4}}), Line(origin = {-39.9701, -69.3732}, points = {{-5, -4}, {5, 4}}), Line(origin = {-72.3432, -69.4627}, points = {{-5, -4}, {5, 4}}), Polygon(origin = {0, 12}, fillColor = {211, 60, 14}, fillPattern = FillPattern.CrossDiag, points = {{-100, -84}, {0, 88}, {100, -84}, {34, -84}, {-100, -84}}), Ellipse(origin = {60, 84}, fillColor = {30, 30, 238}, fillPattern = FillPattern.Solid, extent = {{-38, 12}, {38, -12}}, endAngle = 360), Ellipse(origin = {77, 69}, fillColor = {48, 141, 255}, fillPattern = FillPattern.Solid, extent = {{-25, 9}, {25, -9}}, endAngle = 360), Ellipse(origin = {52, 71}, fillColor = {103, 117, 244}, fillPattern = FillPattern.Solid, extent = {{14, 9}, {-14, -9}}, endAngle = 360), Polygon(origin = {-52, 36}, fillColor = {81, 75, 74}, fillPattern = FillPattern.Solid, points = {{-12, -46}, {12, -6}, {12, 46}, {-12, 46}, {-12, 40}, {-12, -46}})}, coordinateSystem(initialScale = 0.1)));
      end Decke;
     annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-1, 80}, fillColor = {208, 41, 18}, fillPattern = FillPattern.CrossDiag, lineThickness = 2.75, points = {{1, 20}, {-99, -20}, {99, -20}, {1, 20}}), Rectangle(origin = {-1, -20}, lineThickness = 2.75, extent = {{-99, 80}, {99, -80}}), Rectangle(origin = {-1, -80}, fillPattern = FillPattern.Solid, extent = {{-99, 20}, {99, -20}})}));
    end Gebaeude;

    package Sonderkomponenten
      model Boolsche_Senke
        Flaschenzug.Ports.BoolIn boolIn1 annotation(
          Placement(visible = true, transformation(origin = {-114, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, -8.88178e-16}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      equation

        annotation(
          Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {-108, 54}, lineThickness = 0.5, extent = {{38, 16}, {178, -48}})}),
          Documentation(info = "<html><head></head><body>Die Boolsche_Senke ist eine Senke für boolschen Werte. Sollte im Gesamtmodell ein offener Boolscher Output offen sein, dann die Senke dazu benutzt werden, den wer aufzunehmen.</body></html>"));
      end Boolsche_Senke;

      model Boolsche_Quelle
      Flaschenzug.Ports.BoolOut boolOut1 annotation(
          Placement(visible = true, transformation(origin = {130, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 3.55271e-15}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
      
      //Startparameter
      parameter Boolean Eingabe = false annotation(
          Dialog(group = "Ausgabe"));
          
      //Aenderung nach einem bestimmten Zeitpunkt
      parameter Boolean Aenderung = false annotation(
          Dialog(group = "Zeitgesteuert ändern auf"));
      parameter Real nach (unit "s") = 1 annotation(
          Dialog(group = "Zeitgesteuert ändern auf"));
      
      equation
      
      
      if time<= nach then
        boolOut1=Aenderung;
      else
        boolOut1=Eingabe;
      end if;

      annotation(
          Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-100, 100}, {100, -100}}), Line(origin = {15.48, 9.93}, points = {{-73.1063, -71.1063}, {-15.1063, -71.1063}, {-15.1063, 62.8937}, {40.8937, 62.8937}}, thickness = 1)}),
          Documentation(info = "<html><head></head><body>Die Boolsche Quelle ermögtlicht bie Modellierungen ein boolsches Signal konstant zu halten, oder zeitgesteuert zu ändern. Das erzeugte Signal wird aus dem boolschen Output-Port ausgegeben.<div><br></div><div><b>Folgende Parameter </b>stehen zur Verfügung:</div><div>\"Eingabe\": Dieser Wert nimmt der boolsche Ausgangsport von Beginn an der Simulatiin an</div><div>\"nach\": soll eine Änderung des boolschen Wertes bei einem bestimmten Zeitpunkt erfolgen, so kann unter der Angabe \"nach\" der Zeitpunkt eingegeben werden.</div><div>\"Aenderung\": Diesen Wert nimmt der boolsche Ausgangsport ab dem Zeitpunkt \"nach\" an.</div><div><br></div><div><b>Hinweiß:</b></div><div>Soll keine Änderung des boolschen Wertes simuliert werden, kann entweder der Parameter \"nach\" auf einen Zeitpunktnach dem Simulationsende, oder \"Anderung\"=\"Eingabe\" &nbsp;gesetzt werden.</div></body></html>"));end Boolsche_Quelle;
  annotation(
        Icon(graphics = {Polygon(origin = {-40, 0}, fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, points = {{-60, 0}, {60, 100}, {60, -100}, {-60, 0}}), Polygon(origin = {40, 0}, fillColor = {0, 255, 255}, fillPattern = FillPattern.Solid, points = {{-60, -2}, {60, 100}, {60, -100}, {-60, -2}})}));
    end Sonderkomponenten;
    annotation(
      Icon(graphics = {Rectangle(origin = {-50, 50}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Rectangle(origin = {48, 50}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Rectangle(origin = {-48, -50}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Rectangle(origin = {50, -50}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Rectangle(origin = {9, -8}, lineThickness = 2, extent = {{-109, 108}, {91, -92}})}));
  end Modelle;

  package Prototyp

    model Flaschenzug_Boden
    Flaschenzug.Modelle.Spannungsquellen.Spannung spannung1 annotation(
        Placement(visible = true, transformation(origin = {-76, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Gebaeude.Decke decke1 annotation(
        Placement(visible = true, transformation(origin = {74, 76}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Flaschenzug.Modelle.Antriebskomponenten.Getriebe getriebe1 annotation(
        Placement(visible = true, transformation(origin = {-2, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Antriebskomponenten.Motor motor1 annotation(
        Placement(visible = true, transformation(origin = {-76, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Antriebskomponenten.Bremse bremse1 annotation(
        Placement(visible = true, transformation(origin = {-40, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Massen.Masse masse1 annotation(
        Placement(visible = true, transformation(origin = {76, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Flaschenzuege.Flaschenzug_Modell flaschenzug_Modell1 annotation(
        Placement(visible = true, transformation(origin = {75, 17}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Flaschenzug.Modelle.Seilwinden.Seilwinde seilwinde1 annotation(
        Placement(visible = true, transformation(origin = {33, -47}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
    equation
      connect(spannung1.boolIn1, flaschenzug_Modell1.boolOut1) annotation(
        Line(points = {{-90, -20}, {-98, -20}, {-98, 36}, {72, 36}, {72, 36}}));
      connect(spannung1.boolOut1, bremse1.boolIn1) annotation(
        Line(points = {{-90, -14}, {-94, -14}, {-94, 0}, {-54, 0}, {-54, -44}, {-46, -44}, {-46, -42}}));
      connect(motor1.u_i, spannung1.u_i) annotation(
        Line(points = {{-86, -48}, {-94, -48}, {-94, -34}, {-58, -34}, {-58, -20}, {-64, -20}, {-64, -20}}));
      connect(flaschenzug_Modell1.f_s1, decke1.f_s1) annotation(
        Line(points = {{76, 42}, {74, 42}, {74, 54}, {74, 54}}));
      connect(flaschenzug_Modell1.f_s, masse1.f_s) annotation(
        Line(points = {{76, -10}, {76, -10}, {76, -26}, {76, -26}}));
      connect(seilwinde1.f_s, flaschenzug_Modell1.f_s2) annotation(
        Line(points = {{40, -32}, {48, -32}, {48, 10}, {48, 10}}));
      connect(getriebe1.m_w, seilwinde1.m_w) annotation(
        Line(points = {{10, -52}, {16, -52}, {16, -46}, {18, -46}}));
      connect(bremse1.m_w2, getriebe1.m_w1) annotation(
        Line(points = {{-28, -48}, {-20, -48}, {-20, -46}, {-14, -46}, {-14, -46}}));
      connect(motor1.m_w, bremse1.m_w1) annotation(
        Line(points = {{-66, -48}, {-52, -48}, {-52, -48}, {-52, -48}}));
      annotation(
        Diagram(graphics = {Rectangle(origin = {0, -56}, fillPattern = FillPattern.Solid, extent = {{-100, -44}, {100, -4}})}, coordinateSystem(initialScale = 0.1)),
        Icon(graphics = {Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}}), Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}})}, coordinateSystem(initialScale = 0.1)));

    end Flaschenzug_Boden;

    model Flaschenzug_Decke
      Flaschenzug.Modelle.Spannungsquellen.Spannung spannung1 annotation(
        Placement(visible = true, transformation(origin = {-64, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelle.Seilwinden.Seilwinde_Decke seilwinde_Decke1 annotation(
        Placement(visible = true, transformation(origin = {40, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Flaschenzug.Modelle.Gebaeude.Decke decke1 annotation(
        Placement(visible = true, transformation(origin = {74, 74}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
      Flaschenzug.Modelle.Flaschenzuege.Flaschenzug_Modell_b flaschenzug_Modell_b1 annotation(
        Placement(visible = true, transformation(origin = {75, 9}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
      Modelle.Antriebskomponenten.Getriebe getriebe1 annotation(
        Placement(visible = true, transformation(origin = {8, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Flaschenzug.Modelle.Antriebskomponenten.Motor motor1 annotation(
        Placement(visible = true, transformation(origin = {-66, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelle.Antriebskomponenten.Bremse bremse1 annotation(
        Placement(visible = true, transformation(origin = {-24, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelle.Massen.Bierkasten bierkasten1 annotation(
        Placement(visible = true, transformation(origin = {76, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(spannung1.boolIn1, flaschenzug_Modell_b1.boolOut1) annotation(
        Line(points = {{-76, -34}, {-90, -34}, {-90, -54}, {94, -54}, {94, 28}, {78, 28}, {78, 28}}));
      connect(spannung1.boolOut1, bremse1.boolIn1) annotation(
        Line(points = {{-78, -28}, {-92, -28}, {-92, 64}, {-38, 64}, {-38, 50}, {-30, 50}, {-30, 50}}));
      connect(spannung1.u_i, motor1.u_i) annotation(
        Line(points = {{-52, -34}, {-52, 22}, {-84, 22}, {-84, 44}, {-76, 44}, {-76, 46}}));
      connect(motor1.m_w, bremse1.m_w1) annotation(
        Line(points = {{-56, 46}, {-36, 46}, {-36, 44}, {-36, 44}}));
      connect(bremse1.m_w2, getriebe1.m_w1) annotation(
        Line(points = {{-12, 44}, {-4, 44}, {-4, 50}, {-4, 50}}));
      connect(getriebe1.m_w, seilwinde_Decke1.m_w) annotation(
        Line(points = {{20, 44}, {28, 44}, {28, 46}, {28, 46}}));
      connect(seilwinde_Decke1.f_s, flaschenzug_Modell_b1.f_s2) annotation(
        Line(points = {{46, 34}, {48, 34}, {48, 22}, {48, 22}}));
      connect(flaschenzug_Modell_b1.f_s1, decke1.f_s1) annotation(
        Line(points = {{76, 34}, {76, 34}, {76, 52}, {74, 52}}));
      connect(bierkasten1.f_s, flaschenzug_Modell_b1.f_s) annotation(
        Line(points = {{76, -30}, {74, -30}, {74, -18}, {76, -18}}));
      annotation(
        Diagram(graphics = {Rectangle(origin = {0, -2}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {0, -56}, fillPattern = FillPattern.Solid, extent = {{-100, -44}, {100, -4}}), Rectangle(origin = {-26, 55}, fillPattern = FillPattern.Solid, extent = {{74, -1}, {-74, 1}})}, coordinateSystem(initialScale = 0.1)),
        Icon(graphics = {Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}}), Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}})}, coordinateSystem(initialScale = 0.1)));
    end Flaschenzug_Decke;

    model Flaschenzug_Boden_Heben_Senken
      Flaschenzug.Modelle.Gebaeude.Decke decke1 annotation(
        Placement(visible = true, transformation(origin = {74, 76}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
      Flaschenzug.Modelle.Antriebskomponenten.Getriebe getriebe1 annotation(
        Placement(visible = true, transformation(origin = {-2, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Flaschenzug.Modelle.Antriebskomponenten.Motor motor1 annotation(
        Placement(visible = true, transformation(origin = {-76, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Flaschenzug.Modelle.Antriebskomponenten.Bremse bremse1 annotation(
        Placement(visible = true, transformation(origin = {-40, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Flaschenzug.Modelle.Massen.Masse masse1 annotation(
        Placement(visible = true, transformation(origin = {76, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Flaschenzug.Modelle.Flaschenzuege.Flaschenzug_Modell flaschenzug_Modell1 annotation(
        Placement(visible = true, transformation(origin = {75, 17}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
      Flaschenzug.Modelle.Seilwinden.Seilwinde seilwinde1 annotation(
        Placement(visible = true, transformation(origin = {33, -47}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelle.Spannungsquellen.Spannung_Zeitverlauf spannung_Zeitverlauf1 annotation(
        Placement(visible = true, transformation(origin = {-78, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(spannung_Zeitverlauf1.boolIn1, flaschenzug_Modell1.boolOut1) annotation(
        Line(points = {{-92, -18}, {-98, -18}, {-98, 36}, {72, 36}, {72, 36}}));
      connect(spannung_Zeitverlauf1.boolOut1, bremse1.boolIn1) annotation(
        Line(points = {{-92, -12}, {-96, -12}, {-96, 0}, {-52, 0}, {-52, -42}, {-46, -42}, {-46, -42}}));
      connect(motor1.u_i, spannung_Zeitverlauf1.u_i) annotation(
        Line(points = {{-86, -48}, {-92, -48}, {-92, -36}, {-60, -36}, {-60, -18}, {-66, -18}, {-66, -18}}));
      connect(flaschenzug_Modell1.f_s1, decke1.f_s1) annotation(
        Line(points = {{76, 42}, {74, 42}, {74, 54}, {74, 54}}));
      connect(flaschenzug_Modell1.f_s, masse1.f_s) annotation(
        Line(points = {{76, -10}, {76, -10}, {76, -26}, {76, -26}}));
      connect(seilwinde1.f_s, flaschenzug_Modell1.f_s2) annotation(
        Line(points = {{40, -32}, {48, -32}, {48, 10}, {48, 10}}));
      connect(getriebe1.m_w, seilwinde1.m_w) annotation(
        Line(points = {{10, -52}, {16, -52}, {16, -46}, {18, -46}}));
      connect(bremse1.m_w2, getriebe1.m_w1) annotation(
        Line(points = {{-28, -48}, {-20, -48}, {-20, -46}, {-14, -46}, {-14, -46}}));
      connect(motor1.m_w, bremse1.m_w1) annotation(
        Line(points = {{-66, -48}, {-52, -48}, {-52, -48}, {-52, -48}}));
      annotation(
        Diagram(graphics = {Rectangle(origin = {0, -56}, fillPattern = FillPattern.Solid, extent = {{-100, -44}, {100, -4}})}, coordinateSystem(initialScale = 0.1)),
        Icon(graphics = {Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}}), Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}})}, coordinateSystem(initialScale = 0.1)));
    end Flaschenzug_Boden_Heben_Senken;
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}}), Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}})}));
  end Prototyp;
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-1, 80}, fillColor = {208, 41, 18}, fillPattern = FillPattern.CrossDiag, lineThickness = 2.75, points = {{1, 20}, {-99, -20}, {99, -20}, {1, 20}}), Rectangle(origin = {-1, -20}, lineThickness = 2.75, extent = {{-99, 80}, {99, -80}}), Rectangle(origin = {-1, -80}, fillPattern = FillPattern.Solid, extent = {{-99, 20}, {99, -20}}), Rectangle(origin = {-67, -41}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Rectangle(origin = {-17, -41}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Rectangle(origin = {17, 41}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Rectangle(origin = {61, -41}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Line(origin = {-82.4624, -38.3131}, points = {{-15.0582, -1.05816}, {-1.05816, -1.05816}, {14.9418, 0.941844}}, thickness = 4), Line(origin = {-82.4624, -38.3131}, points = {{-15.0582, -1.05816}, {-1.05816, -1.05816}, {14.9418, 0.941844}}, thickness = 4), Line(origin = {-31.9997, -38.3131}, points = {{-15.0582, -1.05816}, {-1.05816, -1.05816}, {14.9418, 0.941844}}, thickness = 4), Line(origin = {-0.656432, 27.5078}, points = {{-11.0582, -55.0582}, {-1.05816, -1.05816}, {14.9418, 0.941844}}, thickness = 4), Line(origin = {48.2391, -26.7161}, points = {{-17.0582, 58.9418}, {-1.05816, -1.05816}, {14.9418, 0.941844}}, thickness = 4)}));
end Flaschenzug;
