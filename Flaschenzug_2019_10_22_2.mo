package Flaschenzug
  connector F_s
    Modelica.SIunits.Position s;
    flow Modelica.SIunits.Force F;
    annotation(
      Icon(graphics = {Rectangle(origin = {-71, 90}, fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-29, 10}, {171, -190}}), Text(origin = {-109, 76}, extent = {{-9, 6}, {233, -132}}, textString = "F_s")}, coordinateSystem(initialScale = 0.1)),
      Diagram(coordinateSystem(initialScale = 0.1)));
  end F_s;

  model Masse
    Flaschenzug.F_s f_s1 annotation(
      Placement(visible = true, transformation(origin = {0, 6}, extent = {{-48, -48}, {48, 48}}, rotation = 0), iconTransformation(origin = {2, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    parameter Modelica.SIunits.Mass m = 100 "Masse";
    //Masse
    Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
    //Erdbeschleunigung
    Real a, v;
  equation
    f_s1.F = m * g + m * a;
    der(v) = a;
    der(f_s1.s) = v;
    annotation(
      Icon(graphics = {Polygon(fillColor = {102, 102, 102}, fillPattern = FillPattern.Solid, points = {{-100, 60}, {-60, 100}, {60, 100}, {100, 60}, {100, -100}, {-100, -100}, {-100, -84}, {-100, 60}}), Text(origin = {-35, 33}, lineColor = {221, 221, 221}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid, extent = {{-27, 23}, {97, -77}}, textString = "Masse")}, coordinateSystem(initialScale = 0.1)));
  end Masse;

  model Flaschenzug_Modell
    Flaschenzug.F_s f_s1 annotation(
      Placement(visible = true, transformation(origin = {-58, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-117, -29}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    Flaschenzug.F_s f_s2 annotation(
      Placement(visible = true, transformation(origin = {-12, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {1, 117}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    Flaschenzug.F_s f_s3 annotation(
      Placement(visible = true, transformation(origin = {86, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {3, -117}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    parameter Integer n = 3 "Anzahl der Rollen";
    parameter Modelica.SIunits.Length s = 1 "Anfangslänge";
    parameter Modelica.SIunits.Angle Zugwinkel = 45 "Zugwinkel";
    parameter Modelica.SIunits.Weight Flaschengewicht_unten = 2 "[kg]";
    Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
    //Erdbeschleunigung
  equation
//if(f_s3.s==f_s2.s){ //Stoppen, wenn Flaschenzug ganz zusammengefahren
    f_s1.F = (f_s3.F - Flaschengewicht_unten * g) / n;
    f_s3.s = f_s2.s - s - f_s1.s / n;
    f_s2.F = f_s3.F + cos(Zugwinkel) * f_s1.F - Flaschengewicht_unten * g;
    annotation(
      Icon(graphics = {Rectangle(origin = {-3, -65}, fillPattern = FillPattern.Solid, extent = {{-1, 3}, {9, -35}}), Rectangle(origin = {-3, 69}, fillPattern = FillPattern.Solid, extent = {{-1, 31}, {9, -47}}), Line(origin = {-69.18, 25}, points = {{53, 58}, {-31, -56}}, color = {255, 0, 0}, thickness = 1), Line(origin = {-20.75, -33.27}, points = {{11, 57}, {9, -51}}, color = {255, 85, 0}, thickness = 1), Line(origin = {22.42, 44.31}, points = {{0, 27}, {-8, -127}}, color = {255, 85, 0}, thickness = 1), Line(origin = {43.12, -11.31}, points = {{-31, 32}, {-41, -50}}, color = {255, 85, 0}, thickness = 1), Ellipse(origin = {4, 71}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-24, 23}, {20, -21}}, endAngle = 360), Ellipse(origin = {4, -84}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-18, 16}, {12, -14}}, endAngle = 360), Ellipse(origin = {1, 21}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-13, 15}, {13, -11}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
  end Flaschenzug_Modell;

  model Seilwinde
    Flaschenzug.M_w m_w1 annotation(
      Placement(visible = true, transformation(origin = {-70, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, -5.32907e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Flaschenzug.F_s f_s1 annotation(
      Placement(visible = true, transformation(origin = {6, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    parameter Modelica.SIunits.Diameter Durchmesser = 0.2 "Trommeldurchmesser";
    constant Real Pi = 2 * Modelica.Math.asin(1.0);
    parameter Modelica.SIunits.Momentum Lagerwiderstand = 0.0 "[Nm]";
    //parameter Modelica.SIunits.Mass m= 5 "[kg]";
  equation
    f_s1.F = (m_w1.M - Lagerwiderstand) / (Durchmesser / 2);
    f_s1.s = Pi * Durchmesser * (m_w1.w / (2 * Pi));
//  (der(f_s1.s)/der((m_w1.w*Pi)/180))^2= (Durchmesser/2)^2;
//f_s1.F*Durchmesser/2 - m_w1.M = 0;
    annotation(
      Icon(graphics = {Rectangle(origin = {-44, 25}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-56, 15}, {144, -65}}), Line(origin = {42.7034, 3.51}, points = {{18, 97}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-17.8189, 3.16671}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {1.89746, 1.88313}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {21.9273, 3.10701}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1)}, coordinateSystem(initialScale = 0.1)));
  end Seilwinde;

  connector M_w
    flow Modelica.SIunits.Momentum M;
    Modelica.SIunits.Angle w;
    annotation(
      Icon(graphics = {Rectangle(origin = {-67, 86}, fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-33, 14}, {167, -186}}), Text(origin = {-49, 49}, extent = {{-9, 7}, {107, -97}}, textString = "M_w")}, coordinateSystem(initialScale = 0.1)));
  end M_w;

  model Getriebe
    Flaschenzug.M_w m_w1 annotation(
      Placement(visible = true, transformation(origin = {-60, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-123, 41}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
    Flaschenzug.M_w m_w2 annotation(
      Placement(visible = true, transformation(origin = {52, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {122, -28}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    parameter Real Uebersetzung = 3 "Übersetzung";
    parameter Modelica.SIunits.Efficiency Wirkungsgrad = 95 "Wirkungsgrad [%]";
    parameter Modelica.SIunits.MomentOfInertia J = 0.05 "Trägheitsmoment [kgm2]";
  equation
    m_w2.M = m_w1.M * Uebersetzung * (Wirkungsgrad / 100);
    m_w2.w = m_w1.w / Uebersetzung;
//m_w2.w+m_w1.w/Uebersetzung=0; //Drehwinkel im Getriebe
//m_w2.M+m_w1.M*Uebersetzung*(Wirkungsgrad/100)=0;
    annotation(
      Icon(graphics = {Rectangle(origin = {-77, 61}, lineColor = {70, 70, 70}, lineThickness = 4, extent = {{-23, 39}, {177, -159}}), Rectangle(origin = {91, -32}, fillColor = {52, 52, 52}, fillPattern = FillPattern.Solid, extent = {{-161, 10}, {11, -8}}), Rectangle(origin = {-75, 38}, fillColor = {52, 52, 52}, fillPattern = FillPattern.Solid, extent = {{-27, 6}, {119, -4}}), Rectangle(origin = {-9, 68}, fillColor = {159, 159, 159}, fillPattern = FillPattern.Forward, extent = {{-10, 7}, {20, -65}}), Rectangle(origin = {-19, -4}, fillColor = {106, 106, 106}, fillPattern = FillPattern.Forward, extent = {{-4, 7}, {34, -81}}), Rectangle(origin = {32, 59}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Rectangle(origin = {72, 58}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Ellipse(origin = {32, 56}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-82, 27}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-82, 24}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-42, 26}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {-82, 59}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-82, 56}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-42, 58}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-24, -6}}), Rectangle(origin = {-56, -7}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-56, -10}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-16, -8}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-24, -6}}), Rectangle(origin = {-56, -47}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-56, -50}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-16, -48}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {82, -47}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {82, -50}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {122, -48}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {82, -7}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {82, -10}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {122, -8}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {32, 27}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {32, 24}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {72, 26}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Text(origin = {-83, 84}, extent = {{-13, 10}, {13, -10}}, textString = "IN"), Text(origin = {79, -84}, extent = {{-13, 10}, {13, -10}}, textString = "OUT")}, coordinateSystem(initialScale = 0.1)));
  end Getriebe;

  model Motor
    Flaschenzug.M_w m_w1 annotation(
      Placement(visible = true, transformation(origin = {28, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {119, 1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    //Gleichstrommotor
        parameter Real KF = 0.05 "Motorkonstante";
        parameter Real RA = 10 "Ankerwiderstand";
        parameter Real J = 0.0001 "Traegheit";
        parameter Real UT = 240 "Eingangsspannung";
        parameter Real LA = 0.01 "Induktivität";
        parameter Real Tst = 0.005 "Zeitkonstante des Stromrichters";
        parameter Real Kst = 2 "Verstärkungsfaktor des Stromes";
        //parameter Boolean enable = true "On/Off Motor";
        Real MA, UI, IA;
        //https://www.elektro.net/wp-content/uploads/jahrbuecher/em12/Formeln.pdf
                    //https://www.autotec.ch/technik/pdf/emo_Drehstrommotor.pdf
                    //Einphasiger E-Motor http://www.energie.ch/asynchronmaschine
                    // kleine Leistungen und schlechter Wirkungsgrad (gespalteter Stator -> SPaltmotor einphasiger Asynchronmotor
             //       M = m*p *(((1-O)*x)/(Ls*(1+O^2*x^2)))*(Us^2/wz^2); // Drehmoment in Funktion der Statorspannung Us
              //      R = wz/p;                                         // Leerlaufdrehzahl auch synchrone Drehzahl genannt
               //     s = wr/wz;                                        // Schlupf im Stillstand s=1 im Leerlauf s=0
                //    Mk = m*p *((1-O)/(2*O*Ls))*(Us^2/wz^2);           // Kippmoment das maximale Drehmoment des Motors im Betrieb
                 //   sk = Rr/(wz*Lr*O);                                // Kippschlupf der Schlupf, bei dem das Kippmoment wirkt
                 //   O = 1- (Lh^2/(Ls*Lr);                             // Streuung
                  //  x = (wr*Lr)/(Rr);                                 // Rotorhilfswert drehzahlabhängig
                  //  M = (2*Mk)/((s/sk) +(sk/s));                      // Drehmoment Formel von Kloss
                    
      equation
    // Gleichstrommotor
        MA = KF * IA;
        der(m_w1.w) = 1 / J * (MA - m_w1.M);
        UI = KF * m_w1.w;
        UT = RA * IA + UI + LA * der(IA);
    //Tst*der(UI)+UI=Kst*UT;
        annotation(
          Icon(graphics = {Rectangle(origin = {-35, -17}, fillColor = {186, 186, 186}, fillPattern = FillPattern.Horizontal, lineThickness = 1, extent = {{-65, 117}, {135, -83}}), Text(origin = {-40, 31}, extent = {{-10, 5}, {90, -65}}, textString = "Motor")}, coordinateSystem(initialScale = 0.1)));
      
  end Motor;

  model Decke
    Flaschenzug.F_s f_s1 annotation(
      Placement(visible = true, transformation(origin = {-22, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -88}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    parameter Modelica.SIunits.Height Hoehe = 4 "Höhe [m]";
  equation
    f_s1.s = Hoehe;
    annotation(
      Icon(graphics = {Rectangle(origin = {0, -74}, fillPattern = FillPattern.Solid, extent = {{-100, 2}, {100, -2}}), Line(origin = {-29.3731, -69.4329}, points = {{-5, -4}, {5, 4}}), Line(origin = {41.0299, -69.5523}, points = {{-5, -4}, {5, 4}}), Line(origin = {-80.7164, -69.6866}, points = {{-5, -4}, {5, 4}}), Line(origin = {55.4179, -69.2687}, points = {{-5, -4}, {5, 4}}), Line(origin = {-60.0597, -70.0299}, points = {{-5, -4}, {5, 4}}), Line(origin = {-3.38808, -69.7762}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {-49.7462, -69.7463}, points = {{-5, -4}, {5, 4}}), Line(origin = {-80.7164, -69.6866}, points = {{-5, -4}, {5, 4}}), Line(origin = {80.7463, -70.2687}, points = {{-5, -4}, {5, 4}}), Line(origin = {26.6418, -69.5225}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {11.6269, -69.4926}, points = {{-5, -4}, {5, 4}}), Line(origin = {-17.3283, -69.9254}, points = {{-5, -4}, {5, 4}}), Line(origin = {67.2985, -69.9254}, points = {{-5, -4}, {5, 4}}), Line(origin = {-39.9701, -69.3732}, points = {{-5, -4}, {5, 4}}), Line(origin = {-72.3432, -69.4627}, points = {{-5, -4}, {5, 4}}), Polygon(origin = {0, 12}, fillColor = {211, 60, 14}, fillPattern = FillPattern.CrossDiag, points = {{-100, -84}, {0, 88}, {100, -84}, {34, -84}, {-100, -84}}), Ellipse(origin = {60, 84}, fillColor = {30, 30, 238}, fillPattern = FillPattern.Solid, extent = {{-38, 12}, {38, -12}}, endAngle = 360), Ellipse(origin = {77, 69}, fillColor = {48, 141, 255}, fillPattern = FillPattern.Solid, extent = {{-25, 9}, {25, -9}}, endAngle = 360), Ellipse(origin = {52, 71}, fillColor = {103, 117, 244}, fillPattern = FillPattern.Solid, extent = {{14, 9}, {-14, -9}}, endAngle = 360), Ellipse(origin = {-124, 128}, fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {56, -62}}, startAngle = 270, endAngle = 360), Line(origin = {-95.597, 86.1045}, points = {{-4, 13}, {22, -109}}, color = {255, 255, 0}, thickness = 0.5), Line(origin = {-95, 86.7015}, points = {{-4, 13}, {38, -85}}, color = {255, 255, 0}, thickness = 0.5), Line(origin = {-95.0299, 86.0448}, points = {{-4, 13}, {62, -41}}, color = {255, 255, 0}, thickness = 0.5), Line(origin = {-94.7462, 87.2687}, points = {{-4, 13}, {50, -63}}, color = {255, 255, 0}, thickness = 0.5), Line(origin = {-94.1492, 87.2386}, points = {{-4, 13}, {72, -19}}, color = {255, 255, 0}, thickness = 0.5), Polygon(origin = {-52, 36}, fillColor = {81, 75, 74}, fillPattern = FillPattern.Solid, points = {{-12, -46}, {12, -6}, {12, 46}, {-12, 46}, {-12, 40}, {-12, -46}})}, coordinateSystem(initialScale = 0.1)));
  end Decke;

  model Prototyp_1
    Flaschenzug.Masse masse1(m = 40) annotation(
      Placement(visible = true, transformation(origin = {0, -46}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    Flaschenzug.Flaschenzug_Modell flaschenzug_Modell1(n = 4, s = 4) annotation(
      Placement(visible = true, transformation(origin = {15, -7}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
    Flaschenzug.Decke decke1 annotation(
      Placement(visible = true, transformation(origin = {17, 39}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    Flaschenzug.Masse masse2(m = 10) annotation(
      Placement(visible = true, transformation(origin = {18, -46}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  equation
    connect(masse2.f_s1, flaschenzug_Modell1.f_s3) annotation(
      Line(points = {{18.12, -38.8}, {16.62, -38.8}, {16.62, -40.8}, {15.12, -40.8}, {15.12, -21.8}}));
    connect(flaschenzug_Modell1.f_s2, decke1.f_s1) annotation(
      Line(points = {{16, 8}, {16, 13}, {17, 13}, {17, 17}}));
    connect(masse1.f_s1, flaschenzug_Modell1.f_s1) annotation(
      Line(points = {{0.16, -36.4}, {0.16, -10.4}}));
  end Prototyp_1;

  model Prototyp_2
    Flaschenzug.Masse masse1(m = 10) annotation(
      Placement(visible = true, transformation(origin = {59, -41}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
    Flaschenzug.Seilwinde seilwinde1 annotation(
      Placement(visible = true, transformation(origin = {12, -46}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
    Flaschenzug.Flaschenzug_Modell flaschenzug_Modell1(Flaschengewicht_unten = 0) annotation(
      Placement(visible = true, transformation(origin = {60, 4}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
    Flaschenzug.Decke decke1 annotation(
      Placement(visible = true, transformation(origin = {60, 64}, extent = {{-28, -28}, {28, 28}}, rotation = 0)));
    Flaschenzug.Getriebe getriebe1(Wirkungsgrad = 100) annotation(
      Placement(visible = true, transformation(origin = {-39, -45}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
    Flaschenzug.Motor motor(UT = 232) annotation(
      Placement(visible = true, transformation(origin = {-86, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(flaschenzug_Modell1.f_s1, seilwinde1.f_s1) annotation(
      Line(points = {{39, -1}, {25, -1}, {25, -20}}));
    connect(getriebe1.m_w2, seilwinde1.m_w1) annotation(
      Line(points = {{-26, -48}, {-20, -48}, {-20, -46}, {-14, -46}}));
    connect(flaschenzug_Modell1.f_s2, decke1.f_s1) annotation(
      Line(points = {{60.18, 25.06}, {60.18, 39.06}}));
    connect(masse1.f_s1, flaschenzug_Modell1.f_s3) annotation(
      Line(points = {{59, -25}, {59, -24.4}, {61.26, -24.4}, {61.26, -17.4}}));
    connect(motor.m_w1, getriebe1.m_w1) annotation(
      Line(points = {{-74, -46}, {-54, -46}, {-54, -40}, {-53, -40}}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {0, 17}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 83}, {100, -117}}), Rectangle(origin = {0, -59}, fillPattern = FillPattern.Solid, extent = {{-100, 3}, {100, -3}})}));
  end Prototyp_2;

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
        Icon(graphics = {Rectangle(origin = {-71, 90}, fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-29, 10}, {171, -190}}), Text(origin = {-109, 76}, extent = {{-9, 6}, {233, -132}}, textString = "F_s")}, coordinateSystem(initialScale = 0.1)),
        Diagram(coordinateSystem(initialScale = 0.1)));
    end F_s;

    connector U_i
      Real U;
      flow Real I;
      annotation(
        Icon(graphics = {Rectangle(fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 8}, extent = {{-70, 50}, {70, -50}}, textString = "U_i"), Rectangle(fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-7, 4}, extent = {{-69, 38}, {69, -38}}, textString = "U_i")}, coordinateSystem(initialScale = 0.1)));
    end U_i;
  end Ports;

  package Modelle
    model Masse
      Flaschenzug.F_s f_s1 annotation(
        Placement(visible = true, transformation(origin = {0, 6}, extent = {{-48, -48}, {48, 48}}, rotation = 0), iconTransformation(origin = {2, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      parameter Modelica.SIunits.Mass m = 100 "Masse";
      //Masse
      Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
      //Erdbeschleunigung
      Real a, v;
    equation
      f_s1.F = m * g + m * a;
      der(v) = a;
      der(f_s1.s) = v;
      annotation(
        Icon(graphics = {Polygon(fillColor = {102, 102, 102}, fillPattern = FillPattern.Solid, points = {{-100, 60}, {-60, 100}, {60, 100}, {100, 60}, {100, -100}, {-100, -100}, {-100, -84}, {-100, 60}}), Text(origin = {-35, 33}, lineColor = {221, 221, 221}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid, extent = {{-27, 23}, {97, -77}}, textString = "Masse")}, coordinateSystem(initialScale = 0.1)));
    end Masse;

    model Flaschenzug_Modell
      Flaschenzug.F_s f_s1 annotation(
        Placement(visible = true, transformation(origin = {-58, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-117, -29}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
      Flaschenzug.F_s f_s2 annotation(
        Placement(visible = true, transformation(origin = {-12, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {1, 117}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
      Flaschenzug.F_s f_s3 annotation(
        Placement(visible = true, transformation(origin = {86, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {3, -117}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
      parameter Integer n = 3 "Anzahl der Rollen";
      parameter Modelica.SIunits.Length s = 1 "Anfangslänge";
      parameter Modelica.SIunits.Angle Zugwinkel = 45 "Zugwinkel";
      parameter Modelica.SIunits.Weight Flaschengewicht_unten = 2 "[kg]";
      Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
      //Erdbeschleunigung
    equation
//if(f_s3.s==f_s2.s){ //Stoppen, wenn Flaschenzug ganz zusammengefahren
      f_s1.F = (f_s3.F - Flaschengewicht_unten * g) / n;
      f_s3.s = f_s2.s - s - f_s1.s / n;
      f_s2.F = f_s3.F + cos(Zugwinkel) * f_s1.F - Flaschengewicht_unten * g;
      annotation(
        Icon(graphics = {Rectangle(origin = {-3, -65}, fillPattern = FillPattern.Solid, extent = {{-1, 3}, {9, -35}}), Rectangle(origin = {-3, 69}, fillPattern = FillPattern.Solid, extent = {{-1, 31}, {9, -47}}), Line(origin = {-69.18, 25}, points = {{53, 58}, {-31, -56}}, color = {255, 0, 0}, thickness = 1), Line(origin = {-20.75, -33.27}, points = {{11, 57}, {9, -51}}, color = {255, 85, 0}, thickness = 1), Line(origin = {22.42, 44.31}, points = {{0, 27}, {-8, -127}}, color = {255, 85, 0}, thickness = 1), Line(origin = {43.12, -11.31}, points = {{-31, 32}, {-41, -50}}, color = {255, 85, 0}, thickness = 1), Ellipse(origin = {4, 71}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-24, 23}, {20, -21}}, endAngle = 360), Ellipse(origin = {4, -84}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-18, 16}, {12, -14}}, endAngle = 360), Ellipse(origin = {1, 21}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-13, 15}, {13, -11}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
    end Flaschenzug_Modell;

    model Seilwinde
      Flaschenzug.M_w m_w1 annotation(
        Placement(visible = true, transformation(origin = {-70, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, -5.32907e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Flaschenzug.F_s f_s1 annotation(
        Placement(visible = true, transformation(origin = {6, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      parameter Modelica.SIunits.Diameter Durchmesser = 0.2 "Trommeldurchmesser";
      constant Real Pi = 2 * Modelica.Math.asin(1.0);
      parameter Modelica.SIunits.Momentum Lagerwiderstand = 0.0 "[Nm]";
      //parameter Modelica.SIunits.Mass m= 5 "[kg]";
    equation
      f_s1.F = (m_w1.M - Lagerwiderstand) / (Durchmesser / 2);
      f_s1.s = Pi * Durchmesser * (m_w1.w / (2 * Pi));
//  (der(f_s1.s)/der((m_w1.w*Pi)/180))^2= (Durchmesser/2)^2;
//f_s1.F*Durchmesser/2 - m_w1.M = 0;
      annotation(
        Icon(graphics = {Rectangle(origin = {-44, 25}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-56, 15}, {144, -65}}), Line(origin = {42.7034, 3.51}, points = {{18, 97}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-17.8189, 3.16671}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {1.89746, 1.88313}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {21.9273, 3.10701}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1)}, coordinateSystem(initialScale = 0.1)));
    end Seilwinde;

    model Getriebe
      Flaschenzug.M_w m_w1 annotation(
        Placement(visible = true, transformation(origin = {-60, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-123, 41}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
      Flaschenzug.M_w m_w2 annotation(
        Placement(visible = true, transformation(origin = {52, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {122, -28}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      parameter Real Uebersetzung = 3 "Übersetzung";
      parameter Modelica.SIunits.Efficiency Wirkungsgrad = 95 "Wirkungsgrad [%]";
      parameter Modelica.SIunits.MomentOfInertia J = 0.05 "Trägheitsmoment [kgm2]";
    equation
      m_w2.M = m_w1.M * Uebersetzung * (Wirkungsgrad / 100);
      m_w2.w = m_w1.w / Uebersetzung;
//m_w2.w+m_w1.w/Uebersetzung=0; //Drehwinkel im Getriebe
//m_w2.M+m_w1.M*Uebersetzung*(Wirkungsgrad/100)=0;
      annotation(
        Icon(graphics = {Rectangle(origin = {-77, 61}, lineColor = {70, 70, 70}, lineThickness = 4, extent = {{-23, 39}, {177, -159}}), Rectangle(origin = {91, -32}, fillColor = {52, 52, 52}, fillPattern = FillPattern.Solid, extent = {{-161, 10}, {11, -8}}), Rectangle(origin = {-75, 38}, fillColor = {52, 52, 52}, fillPattern = FillPattern.Solid, extent = {{-27, 6}, {119, -4}}), Rectangle(origin = {-9, 68}, fillColor = {159, 159, 159}, fillPattern = FillPattern.Forward, extent = {{-10, 7}, {20, -65}}), Rectangle(origin = {-19, -4}, fillColor = {106, 106, 106}, fillPattern = FillPattern.Forward, extent = {{-4, 7}, {34, -81}}), Rectangle(origin = {32, 59}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Rectangle(origin = {72, 58}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Ellipse(origin = {32, 56}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-82, 27}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-82, 24}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-42, 26}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {-82, 59}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-82, 56}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-42, 58}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-24, -6}}), Rectangle(origin = {-56, -7}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-56, -10}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-16, -8}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-24, -6}}), Rectangle(origin = {-56, -47}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-56, -50}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-16, -48}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {82, -47}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {82, -50}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {122, -48}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {82, -7}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {82, -10}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {122, -8}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {32, 27}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {32, 24}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {72, 26}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Text(origin = {-83, 84}, extent = {{-13, 10}, {13, -10}}, textString = "IN"), Text(origin = {79, -84}, extent = {{-13, 10}, {13, -10}}, textString = "OUT")}, coordinateSystem(initialScale = 0.1)));
    end Getriebe;

    model Motor
      Flaschenzug.Ports.M_w m_w annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, -2}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
      constant Real Pi = Modelica.Constants.pi;
      constant Real Ub(unit = "V") = 1.4;        // Buerstenabfallspannung
      constant Real Ra(unit = "Ohm") = 0.2;        // Ankerwiderstand
      constant Real La(unit = "H") = 0;        // Ankerinduktivitaet
      constant Real Jtot(unit = "kg.m2") = 0.005;        // Massentraegheit gesamt
      constant Real kt(unit = "N.m/A") = 0.1;        // Drehmomentkonstante
      constant Real Rfw(unit = "Ohm") = 0;        // Feldwicklungswiderstand
      constant Real Lfw(unit = "H") = 0;        // Feldwicklungsinduktion
      constant Real cf(unit = "N.m.s") = 0.0025;        // Reibungsverlustkonstante
      constant Real cv(unit = "N.m.s2") = 0.000104;        // Ventilationsverlustkonstante
      Real n(unit = "Hz");        // Drehzahl
      Real Mf(unit = "N.m");        // Reibungsmoment
      Real Mv(unit = "N.m");        // Ventilationsmoment
      Real Ua(unit = "V");        // Ankerspannung
      Real Ia(unit = "A");        // Ankerstrom
      Real Ufw(unit = "V");        // Felwicklungsspannung
      Real Ifw(unit = "A");        // Felwicklungsstrom
      Real w(unit = "rad/s");        // Winkelgeschwindigkeit
      Flaschenzug.Ports.U_i u_i annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-107, -1}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    equation
//Formel Heidrich Vorlesung 2 Gleichstrommotor
      u_i.U = Ua + Ufw;
// Reihenschluss
      Ifw = Ia;
//Reihenschluss
      Ia = u_i.I;
      Ua = 2 * Ub + Ra * Ia + La * der(Ia) + kt * w;
      Ufw = Rfw * Ifw + Lfw * der(Ifw);
      kt * Ia = Jtot * der(w) + Mf + Mv + m_w.M;
      Mf = cf * n;
      Mv = sign(n) * cv * n ^ 2;
      w = 2 * Pi * n;
      der(m_w.w) = w;
/*//Gleichstrommotor
      parameter Real KF = 0.05 "Motorkonstante";
      parameter Real RA = 10 "Ankerwiderstand";
      parameter Real J = 0.0001 "Traegheit";
      parameter Real UT = 240 "Eingangsspannung";
      parameter Real LA = 0.01 "Induktivität";
      parameter Real Tst = 0.005 "Zeitkonstante des Stromrichters";
      parameter Real Kst = 2 "Verstärkungsfaktor des Stromes";
      //parameter Boolean enable = true "On/Off Motor";
      Real MA, UI, IA;
      //https://www.elektro.net/wp-content/uploads/jahrbuecher/em12/Formeln.pdf
                  https://www.autotec.ch/technik/pdf/emo_Drehstrommotor.pdf
                  Einphasiger E-Motor http://www.energie.ch/asynchronmaschine
                  // kleine Leistungen und schlechter Wirkungsgrad (gespalteter Stator -> SPaltmotor einphasiger Asynchronmotor
                  M = m*p *(((1-O)*x)/(Ls*(1+O^2*x^2)))*(Us^2/wz^2); // Drehmoment in Funktion der Statorspannung Us
                  R = wz/p;                                         // Leerlaufdrehzahl auch synchrone Drehzahl genannt
                  s = wr/wz;                                        // Schlupf im Stillstand s=1 im Leerlauf s=0
                  Mk = m*p *((1-O)/(2*O*Ls))*(Us^2/wz^2);           // Kippmoment das maximale Drehmoment des Motors im Betrieb
                  sk = Rr/(wz*Lr*O);                                // Kippschlupf der Schlupf, bei dem das Kippmoment wirkt
                  O = 1- (Lh^2/(Ls*Lr);                             // Streuung
                  x = (wr*Lr)/(Rr);                                 // Rotorhilfswert drehzahlabhängig
                  M = (2*Mk)/((s/sk) +(sk/s));                      // Drehmoment Formel von Kloss
                  
    equation
    // Gleichstrommotor
      MA = KF * IA;
      der(m_w1.w) = 1 / J * (MA - m_w1.M);
      UI = KF * m_w1.w;
      UT = RA * IA + UI + LA * der(IA);
    //Tst*der(UI)+UI=Kst*UT;
      annotation(
        Icon(graphics = {Rectangle(origin = {-35, -17}, fillColor = {186, 186, 186}, fillPattern = FillPattern.Horizontal, lineThickness = 1, extent = {{-65, 117}, {135, -83}}), Text(origin = {-40, 31}, extent = {{-10, 5}, {90, -65}}, textString = "Motor")}, coordinateSystem(initialScale = 0.1)));
    */
      annotation(
        Icon(graphics = {Rectangle(origin = {-35, -17}, fillColor = {186, 186, 186}, fillPattern = FillPattern.Horizontal, lineThickness = 1, extent = {{-65, 117}, {135, -83}}), Text(origin = {-40, 31}, extent = {{-10, 5}, {90, -65}}, textString = "Motor")}, coordinateSystem(initialScale = 0.1)));
    end Motor;

    model Decke
      Flaschenzug.F_s f_s1 annotation(
        Placement(visible = true, transformation(origin = {-22, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -88}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
      parameter Modelica.SIunits.Height Hoehe = 4 "Höhe [m]";
    equation
      f_s1.s = Hoehe;
      annotation(
        Icon(graphics = {Rectangle(origin = {0, -74}, fillPattern = FillPattern.Solid, extent = {{-100, 2}, {100, -2}}), Line(origin = {-29.3731, -69.4329}, points = {{-5, -4}, {5, 4}}), Line(origin = {41.0299, -69.5523}, points = {{-5, -4}, {5, 4}}), Line(origin = {-80.7164, -69.6866}, points = {{-5, -4}, {5, 4}}), Line(origin = {55.4179, -69.2687}, points = {{-5, -4}, {5, 4}}), Line(origin = {-60.0597, -70.0299}, points = {{-5, -4}, {5, 4}}), Line(origin = {-3.38808, -69.7762}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {-49.7462, -69.7463}, points = {{-5, -4}, {5, 4}}), Line(origin = {-80.7164, -69.6866}, points = {{-5, -4}, {5, 4}}), Line(origin = {80.7463, -70.2687}, points = {{-5, -4}, {5, 4}}), Line(origin = {26.6418, -69.5225}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {11.6269, -69.4926}, points = {{-5, -4}, {5, 4}}), Line(origin = {-17.3283, -69.9254}, points = {{-5, -4}, {5, 4}}), Line(origin = {67.2985, -69.9254}, points = {{-5, -4}, {5, 4}}), Line(origin = {-39.9701, -69.3732}, points = {{-5, -4}, {5, 4}}), Line(origin = {-72.3432, -69.4627}, points = {{-5, -4}, {5, 4}}), Polygon(origin = {0, 12}, fillColor = {211, 60, 14}, fillPattern = FillPattern.CrossDiag, points = {{-100, -84}, {0, 88}, {100, -84}, {34, -84}, {-100, -84}}), Ellipse(origin = {60, 84}, fillColor = {30, 30, 238}, fillPattern = FillPattern.Solid, extent = {{-38, 12}, {38, -12}}, endAngle = 360), Ellipse(origin = {77, 69}, fillColor = {48, 141, 255}, fillPattern = FillPattern.Solid, extent = {{-25, 9}, {25, -9}}, endAngle = 360), Ellipse(origin = {52, 71}, fillColor = {103, 117, 244}, fillPattern = FillPattern.Solid, extent = {{14, 9}, {-14, -9}}, endAngle = 360), Ellipse(origin = {-124, 128}, fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {56, -62}}, startAngle = 270, endAngle = 360), Line(origin = {-95.597, 86.1045}, points = {{-4, 13}, {22, -109}}, color = {255, 255, 0}, thickness = 0.5), Line(origin = {-95, 86.7015}, points = {{-4, 13}, {38, -85}}, color = {255, 255, 0}, thickness = 0.5), Line(origin = {-95.0299, 86.0448}, points = {{-4, 13}, {62, -41}}, color = {255, 255, 0}, thickness = 0.5), Line(origin = {-94.7462, 87.2687}, points = {{-4, 13}, {50, -63}}, color = {255, 255, 0}, thickness = 0.5), Line(origin = {-94.1492, 87.2386}, points = {{-4, 13}, {72, -19}}, color = {255, 255, 0}, thickness = 0.5), Polygon(origin = {-52, 36}, fillColor = {81, 75, 74}, fillPattern = FillPattern.Solid, points = {{-12, -46}, {12, -6}, {12, 46}, {-12, 46}, {-12, 40}, {-12, -46}})}, coordinateSystem(initialScale = 0.1)));
    end Decke;

    model Spannung
      parameter Real U(unit "V") = 230;
      Flaschenzug.Ports.U_i u_i annotation(
        Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, 0}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
    equation
      U = u_i.U;
      annotation(
        Diagram,
        Icon(graphics = {Ellipse(origin = {4, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Ellipse(origin = {-56, 61}, extent = {{-22, 19}, {128, -127}}, endAngle = 360), Ellipse(origin = {66, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Rectangle(origin = {-10, 10}, extent = {{-90, 90}, {108, -110}})}, coordinateSystem(initialScale = 0.1)));
    end Spannung;
  end Modelle;

  package Prototyp
    model Prototyp_1
      Flaschenzug.Masse masse1(m = 40) annotation(
        Placement(visible = true, transformation(origin = {0, -46}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
      Flaschenzug.Flaschenzug_Modell flaschenzug_Modell1(n = 4, s = 4) annotation(
        Placement(visible = true, transformation(origin = {15, -7}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
      Flaschenzug.Decke decke1 annotation(
        Placement(visible = true, transformation(origin = {17, 39}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
      Flaschenzug.Masse masse2(m = 10) annotation(
        Placement(visible = true, transformation(origin = {18, -46}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    equation
      connect(masse2.f_s1, flaschenzug_Modell1.f_s3) annotation(
        Line(points = {{18.12, -38.8}, {16.62, -38.8}, {16.62, -40.8}, {15.12, -40.8}, {15.12, -21.8}}));
      connect(flaschenzug_Modell1.f_s2, decke1.f_s1) annotation(
        Line(points = {{16, 8}, {16, 13}, {17, 13}, {17, 17}}));
      connect(masse1.f_s1, flaschenzug_Modell1.f_s1) annotation(
        Line(points = {{0.16, -36.4}, {0.16, -10.4}}));
    end Prototyp_1;

    model Prototyp_2
      Flaschenzug.Masse masse1(m = 10) annotation(
        Placement(visible = true, transformation(origin = {59, -41}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
      Flaschenzug.Seilwinde seilwinde1 annotation(
        Placement(visible = true, transformation(origin = {12, -46}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
      Flaschenzug.Flaschenzug_Modell flaschenzug_Modell1(Flaschengewicht_unten = 0) annotation(
        Placement(visible = true, transformation(origin = {60, 4}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
      Flaschenzug.Decke decke1 annotation(
        Placement(visible = true, transformation(origin = {60, 64}, extent = {{-28, -28}, {28, 28}}, rotation = 0)));
      Flaschenzug.Getriebe getriebe1(Wirkungsgrad = 100) annotation(
        Placement(visible = true, transformation(origin = {-39, -45}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
      Flaschenzug.Motor motor(UT = 232) annotation(
        Placement(visible = true, transformation(origin = {-86, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(flaschenzug_Modell1.f_s1, seilwinde1.f_s1) annotation(
        Line(points = {{39, -1}, {25, -1}, {25, -20}}));
      connect(getriebe1.m_w2, seilwinde1.m_w1) annotation(
        Line(points = {{-26, -48}, {-20, -48}, {-20, -46}, {-14, -46}}));
      connect(flaschenzug_Modell1.f_s2, decke1.f_s1) annotation(
        Line(points = {{60.18, 25.06}, {60.18, 39.06}}));
      connect(masse1.f_s1, flaschenzug_Modell1.f_s3) annotation(
        Line(points = {{59, -25}, {59, -24.4}, {61.26, -24.4}, {61.26, -17.4}}));
      connect(motor.m_w1, getriebe1.m_w1) annotation(
        Line(points = {{-74, -46}, {-54, -46}, {-54, -40}, {-53, -40}}));
      annotation(
        Diagram(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {0, 17}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 83}, {100, -117}}), Rectangle(origin = {0, -59}, fillPattern = FillPattern.Solid, extent = {{-100, 3}, {100, -3}})}));
    end Prototyp_2;

    model Final_Prototyp
      Flaschenzug.Modelle.Getriebe getriebe(Uebersetzung = 3, Wirkungsgrad = 100) annotation(
        Placement(visible = true, transformation(origin = {-23, -65}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Flaschenzug.Modelle.Seilwinde seilwinde(Durchmesser = 1) annotation(
        Placement(visible = true, transformation(origin = {30, -68}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Flaschenzug.Modelle.Flaschenzug_Modell flaschenzug_Modell(Zugwinkel(displayUnit = "rad"))  annotation(
        Placement(visible = true, transformation(origin = {66, 2}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
      Flaschenzug.Modelle.Masse masse(m = 9) annotation(
        Placement(visible = true, transformation(origin = {66, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Flaschenzug.Modelle.Decke decke annotation(
        Placement(visible = true, transformation(origin = {66, 66}, extent = {{-32, -32}, {32, 32}}, rotation = 0)));
      Flaschenzug.Modelle.Spannung spannung(U = 48)  annotation(
        Placement(visible = true, transformation(origin = {-90, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Flaschenzug.Modelle.Motor motor annotation(
        Placement(visible = true, transformation(origin = {-60, -68}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    equation
  connect(motor.m_w, getriebe.m_w1) annotation(
        Line(points = {{-47, -68}, {-41, -68}, {-41, -59}}));
      connect(getriebe.m_w2, seilwinde.m_w1) annotation(
        Line(points = {{-5, -69}, {6, -69}, {6, -68}}));
      connect(flaschenzug_Modell.f_s1, seilwinde.f_s1) annotation(
        Line(points = {{31, -7}, {31, -27}, {42, -27}, {42, -44}}));
      connect(flaschenzug_Modell.f_s2, decke.f_s1) annotation(
        Line(points = {{66, 37}, {71, 37}, {71, 38}, {66, 38}}));
  connect(spannung.u_i, motor.u_i) annotation(
        Line(points = {{-73, -68}, {-76.5, -68}, {-76.5, -60}, {-80, -60}}));
  connect(motor.m_w, getriebe.m_w1) annotation(
        Line(points = {{-47, -68}, {-41, -68}, {-41, -59}}));
  connect(motor.u_i, spannung.u_i) annotation(
        Line(points = {{-73, -68}, {-76.5, -68}, {-76.5, -60}, {-80, -60}}));
      connect(masse.f_s1, flaschenzug_Modell.f_s3) annotation(
        Line(points = {{66, -52}, {66, -52}, {66, -34}, {66, -34}}));
      annotation(
        Diagram(graphics = {Rectangle(origin = {0, -81}, fillPattern = FillPattern.Solid, extent = {{-100, 3}, {100, -3}}), Rectangle(origin = {0, 17}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 83}, {100, -117}}), Rectangle(origin = {0, -83}, fillPattern = FillPattern.Solid, extent = {{-100, 3}, {100, -3}})}));
    end Final_Prototyp;

    model Motor_Seilwinde
      Flaschenzug.Modelle.Motor motor annotation(
        Placement(visible = true, transformation(origin = {-60, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Flaschenzug.Modelle.Seilwinde seilwinde(Durchmesser = 1)  annotation(
        Placement(visible = true, transformation(origin = {21, -15}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
      Modelle.Masse masse(m = 1)  annotation(
        Placement(visible = true, transformation(origin = {40, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelle.Spannung spannung(U = 48)  annotation(
        Placement(visible = true, transformation(origin = {-94, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(motor.m_w, seilwinde.m_w1) annotation(
        Line(points = {{-38, -20}, {-14, -20}, {-14, -14}, {-16, -14}}));
      connect(seilwinde.f_s1, masse.f_s1) annotation(
        Line(points = {{40, 22}, {40, 22}, {40, -44}, {40, -44}}));
  connect(spannung.u_i, motor.u_i) annotation(
        Line(points = {{-84, 12}, {-84, 12}, {-84, -20}, {-82, -20}}));
    end Motor_Seilwinde;
  end Prototyp;
end Flaschenzug;
