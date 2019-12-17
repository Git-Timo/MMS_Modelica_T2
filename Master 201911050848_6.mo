package Flaschenzug
  package Ports
    connector M_w
      flow Modelica.SIunits.Torque M;
      Modelica.SIunits.Angle w;
      annotation(
        Icon(graphics = {Rectangle(origin = {-67, 86}, fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-33, 14}, {167, -186}}), Text(origin = {-49, 49}, extent = {{-9, 7}, {107, -97}}, textString = "M_w")}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body><font size=\"4\">Fluss</font><span style=\"font-size: large;\">größe</span><font size=\"4\">: Moment <b>M</b> in Nm</font><div><font size=\"4\">Potenzialgröße: Winkelgeschwindigkeit <b>w</b> in rad</font></div></body></html>"));
    end M_w;

    connector F_s
      Modelica.SIunits.Position s;
      flow Modelica.SIunits.Force F;
      annotation(
        Icon(graphics = {Rectangle(origin = {-71, 90}, fillColor = {255, 193, 46}, fillPattern = FillPattern.Solid, extent = {{-29, 10}, {171, -190}}), Text(origin = {-109, 76}, extent = {{-9, 6}, {233, -132}}, textString = "F_s")}, coordinateSystem(initialScale = 0.1)),
        Diagram(coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body><font size=\"4\">Fluss</font><span style=\"font-size: large;\">größe</span><font size=\"4\">: Kraft <b>F</b>&nbsp;in N</font><div><font size=\"4\">Potenzial</font><span style=\"font-size: large;\">größe</span><font size=\"4\">: Länge&nbsp;<b>s</b>&nbsp;in m</font></div></body></html>"));
    end F_s;

    connector U_i
      Real U;
      flow Real I;
      annotation(
        Icon(graphics = {Rectangle(fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 8}, extent = {{-70, 50}, {70, -50}}, textString = "U_i"), Rectangle(fillColor = {170, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-7, 4}, extent = {{-69, 38}, {69, -38}}, textString = "U_i")}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body><font size=\"4\">Fluss</font><span style=\"font-size: large;\">größe</span><font size=\"4\">: Strom <b>I</b>&nbsp;in Ampere</font><div style=\"font-size: 12px;\"><font size=\"4\">Potenzial</font><span style=\"font-size: large;\">größe</span><font size=\"4\">: Spannung <b>U</b>&nbsp;in Volt</font></div></body></html>"));
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

model Zeitgesteuert
  //Paramter
  parameter Real U(unit "V") = 48 "[V] Spannung beim anheben";
  parameter Real t1(unit "s") = 6 "[s] Masse anheben bis Zeitpunkt";
  parameter Real t2(unit "s") = 10 "[s] Masse halten bis Zeitpunkt";
  parameter Real t3(unit "s") = 11 "[s] Masse senken bis Zeitpunkt";
  parameter Real U_A(unit "V") = 36 "[V] Spannung zum Senken ab Zeitpunkt t2";   
//Variablen
  Real t10; 
  Real I(unit "A");
  //Konstanten
  constant Real t(unit "s") = 1; 
  Boolean KonstanteSpannung = false;
  //Ports
  Flaschenzug.Ports.U_i u_i annotation(
    Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {124, -2}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Flaschenzug.Ports.BoolOut boolOut1 annotation(
    Placement(visible = true, transformation(origin = {-148, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-130, 64}, extent = {{-30, 30}, {30, -30}}, rotation = 0)));

equation
  if KonstanteSpannung == true then
    t10 = time * t;
    U = u_i.U;
    I = u_i.I;
    boolOut1 = false;
  else
    t10 = time * t;
    if t10 <= t1 then
      U = u_i.U;
      I = u_i.I;
      boolOut1 = false;
    elseif t10 > t1 and t10 <= t2 then
      u_i.U = 0;
      I = u_i.I;
      boolOut1 = true;
    elseif t10 > t2 and t10 <= t3 then
      -U_A = -u_i.U;
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
    Icon(graphics = {Ellipse(origin = {4, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Ellipse(origin = {-56, 61}, lineThickness = 1, extent = {{-22, 19}, {128, -127}}, endAngle = 360), Ellipse(origin = {66, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Rectangle(origin = {-10, 10}, lineThickness = 1, extent = {{-90, 90}, {110, -110}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><b>Spannungsquelle Zeitverlauf:</b><div><br></div><div>Mit diesem Spannungsmodell kann die Spannung über die Zeit verändert werden.&nbsp;</div><div>Damit lassen sich <b>Hebezyklen realisieren</b> (Heben, Halten Senken, Halten)</div><div><br></div><div>Dabei kann dieses Modell bei dem Beispiel: \"Flaschenzug_Heben_Senken\" frei parametriert werden.</div><div><br></div><div><span style=\"font-size: 12px;\">Folgende&nbsp;</span><b style=\"font-size: 12px;\">Parameter</b><span style=\"font-size: 12px;\">&nbsp;stehen zur Eingabe bereit:</span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><b>t1</b> -&gt; entspricht der Hebezeit wie lange die Masse nach oben beschleunigt werden soll.&nbsp;</div><div><b>t2</b> -&gt; entspricht dem Zeitpunkt wie lange die Masse gehalten werden soll.</div><div><b>t3</b> -&gt; entspricht dem Zeitpunkt bis wann die Masse abgelassen werden soll. Anschließend wird die Masse auf dieser Höhe gehalten.</div><div><br></div><div><b>U_A&nbsp;</b>-&gt; Spannung die zum Ablassen der Masse eingestellt wird.</div><div><br></div><div><div style=\"font-size: 12px;\"><b>U</b>&nbsp;ist die Spannung für den Betrieb des Motors. Sie kann negativ oder positiv gewählt werden (Drehrichtung). Ein positiver Wert erzeugt eine positive Drehrichtung. Dabei ist zu beachten, dass der Motor genügend Spannung erhält, um die gewünschte Leistung abgeben zu können.</div></div><div><br></div><div><br></div><div><br></div></body></html>"));
end Zeitgesteuert;

      model Konstantspannung
        //Parameter
        parameter Real U(unit "V") = 48 annotation(
          Dialog(group = "Elektrisch"));
        
        parameter Boolean KonstanteSpannung = false annotation(
          Dialog(group = "Betriebsarten"));
        //Variablen
        Real I(unit "A");
        Real t1;
        //Konstanten
        constant Real t = 1;
          //Port
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
          Icon(graphics = {Ellipse(origin = {4, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Ellipse(origin = {-56, 61}, lineThickness = 1, extent = {{-22, 19}, {128, -127}}, endAngle = 360), Ellipse(origin = {66, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Rectangle(origin = {-10, 10}, lineThickness = 1, extent = {{-90, 90}, {110, -110}})}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body><b style=\"font-size: 12px;\">Spannungsquelle Konstantspannung:</b><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Diese Spannungsquelle beinhaltet keine Sensorik (keine Boolean Ein- oder Ausgänge).&nbsp;</div><div style=\"font-size: 12px;\">Diese wird in der Bibliothek zur Verfügung gestellt, um einfache Modelle (z.B. einen Motortest) zu simulieren.&nbsp;</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Folgende&nbsp;<b>Parameter</b>&nbsp;stehen zur Eingabe bereit:</div><div style=\"font-size: 12px;\"><b><br></b></div><div style=\"font-size: 12px;\"><b>U</b>&nbsp;ist die Spannung für den Betrieb des Motors. Sie kann negativ oder positiv gewählt werden (Drehrichtung). Ein positiver Wert erzeugt eine positive Drehrichtung. Dabei ist zu beachten, dass der Motor genügend Spannung erhält, um die gewünschte Leistung abgeben zu können.</div><div style=\"font-size: 12px;\"><br></div></body></html>"));
      end Konstantspannung;

      model Gesteuert
        //Parameter
        parameter Real U(unit "V") = 48 annotation(
          Dialog(group = "Elektrisch"));
        //Variable
        Real I(unit "A");
        //Ports
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
          Icon(graphics = {Ellipse(origin = {4, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Ellipse(origin = {-56, 61}, lineThickness = 1, extent = {{-22, 19}, {128, -127}}, endAngle = 360), Ellipse(origin = {66, 26}, fillPattern = FillPattern.Solid, extent = {{-20, -2}, {-52, -34}}, endAngle = 360), Rectangle(origin = {-10, 10}, lineThickness = 1, extent = {{-90, 90}, {110, -110}})}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body><b>Spannungsquelle gesteuert:</b><div><b><br></b></div><div>Die Spannungsquelle ist durch ein Sensorsignal gesteuert.</div><div><br></div><div>Die nachfolgenden drei IF-Bedingungen werden abgefragt :</div><div><br></div><div><b>1.</b> Ist die Spannung = 0V deffiniert, wird keine Spannung ausgegeben.&nbsp;</div><div>&nbsp; &nbsp; Der Port boolOut1 = 1 und betätigt damit die Bremse.</div><div><b>2.</b> Ist der Port boolIn1 = 1 bedeutet, dass der Flaschenzug auf Block gefahren ist und damit an der Decke angekommen ist.</div><div>&nbsp; &nbsp; Somit schaltet boolOut1 auf 1 und die Bremse wird betätigt.</div><div><b>3. </b>Tritt Fall eins und zwei nicht ein, so legt die Spannungsquelle eine Spannung an den Motor an</div><div><br></div><div><span style=\"font-size: 12px;\">Folgende&nbsp;</span><b style=\"font-size: 12px;\">Parameter</b><span style=\"font-size: 12px;\">&nbsp;stehen zur Eingabe bereit:</span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><b style=\"font-size: 12px;\">U</b><span style=\"font-size: 12px;\">&nbsp;ist die Spannung für den Betrieb des Motors. Sie kann negativ oder positiv gewählt werden (Drehrichtung). Ein positiver Wert erzeugt eine positive Drehrichtung. Dabei ist zu beachten, dass der Motor genügend Spannung erhält, um die gewünschte Leistung abgeben zu können.</span></div><div><br><div><br></div><div><br></div></div></body></html>"));
      end Gesteuert;
      annotation(
        Icon(graphics = {Polygon(fillPattern = FillPattern.Solid, points = {{0, 100}, {-100, -100}, {100, -100}, {100, -100}, {0, 100}}), Polygon(origin = {-1, -2}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{1, 92}, {-91, -94}, {93, -94}, {1, 92}}), Polygon(origin = {-4, -24}, fillPattern = FillPattern.Solid, points = {{0, 64}, {-36, -20}, {8, 6}, {-10, -52}, {-2, -54}, {22, 22}, {-16, 0}, {24, 58}, {0, 64}, {0, 64}}), Polygon(origin = {-7, -77}, fillPattern = FillPattern.Solid, points = {{-13, 9}, {13, 3}, {-5, -9}, {-13, 9}})}));
    end Spannungsquellen;

    package Seilwinden
      model Seilwinde
        //Parameter
        parameter Modelica.SIunits.Diameter Durchmesser = 0.2 "Trommeldurchmesser" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Momentum Lagerwiderstand = 0.0 "[Nm]" annotation(
          Dialog(group = "Trägheit und Verlust"));
        parameter Modelica.SIunits.Diameter d = 0.05 "Seildurchmesser [m]" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length b = 0.4 "Windenbreite [m]" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Mass m = 10 "Masse der Seilwinde excl. Seil" annotation(
          Dialog(group = "Trägheit und Verlust"));
        parameter Boolean Durchmesserkomulation = false annotation(
          Dialog(group = "Betriebsarten"));
        //Konstanten
        constant Real Pi = 2 * Modelica.Math.asin(1.0);
        //Variablen
        Real d_Winde;
        Integer v;
        Real o, dmax, s;
        Real J_Rolle, v_Rolle;
        //Ports
        Flaschenzug.Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {58, 126}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {59, 119}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
        Flaschenzug.Ports.M_w m_w annotation(
          Placement(visible = true, transformation(origin = {-134, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-119, 1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
      equation
  if v - 1 >= 1 and Durchmesserkomulation == true then
//Berechnung des Windendurchmessers als lineare Funktion
          d_Winde = Durchmesser + s * d;
          dmax = Durchmesser + (o - 1) * d * 2;
          s = (-m_w.w / (2 * Pi)) / (b / d) - 1;
        else
//keine Durchmesseraproximation
          d_Winde = Durchmesser;
          dmax = Durchmesser;
          s = 0;
        end if;
//Zurichtungsumkehr
        f_s.F = (m_w.M - Lagerwiderstand) / (d_Winde / 2) - J_Rolle * der(v_Rolle);
//Drehgeschwindigkeit der Rolle
        v_Rolle = der(f_s.s);
//Berechneung des Massenträgheits der Rolle unter Annahme eines massiven Zylinders.
        J_Rolle = 0.5 * m * (Durchmesser / 2) ^ 2;
//berechnet die Anzahl der Schichten +1
        -v = floor(m_w.w / (2 * Pi) / (b / d));
        v = o;
//Ausgabe der Seilposition
        f_s.s = Pi * d_Winde * (m_w.w / (2 * Pi));
        annotation(
          choices(choice(redeclare lib2.Resistor Load(a = {2}) "..."), choice(redeclare Capacitor Load(L = 3) "...")),
          Icon(graphics = {Rectangle(origin = {-44, 25}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-56, 15}, {144, -65}}), Line(origin = {42.7034, 3.51}, points = {{18, 97}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-17.8189, 3.16671}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {1.89746, 1.88313}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {21.9273, 3.10701}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Rectangle(origin = {-92, -10}, fillPattern = FillPattern.Solid, extent = {{-9, 70}, {9, -70}}), Rectangle(origin = {92, -10}, fillPattern = FillPattern.Solid, extent = {{-9, 70}, {9, -70}}), Rectangle(origin = {-13, -61}, rotation = -90, fillPattern = FillPattern.Solid, extent = {{-9, 114}, {41, -88}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body><b>Die Seilwinde</b>&nbsp;dient zur Umwandlung einer Drehbewegung in eine translatorische Bewegung. Durch die Bidirektionalität kann auch eine translatorische Bewegung in eine rotatorische Bewegung umgewandelt werden.&nbsp;<div><br></div><div>Das Modell besitzt zwei Ports: Ein für translatorische Bewegung (f_s) und einen für rotatorische Bewegung (m_w).<br><div><br></div><div>Folgende <b>Parameter</b> stehen zur Eingabe bereit:</div><div><br></div><div><b>Durchmesser: </b>Dieser Parameter beschreibt in der Einheit Meter den Durchmesser der Seiltrommel.</div><div><b>d</b>: Beschreibt den Durchmesser des Seiles in Metern. Da in der Bibliothek die Seildehnung nicht betrachtet wird, ist der Durchmesser des Seiles lastunabhängig und wird als konstant angenommen.</div><div><b>b</b>: Die Breite der Winde in Metern. Unter Berücksichtigung von d wird mit dieser Angabe in der Betriebsart Durchmesserkomulation berechnet, wieviele Umdrehungen das Seil einlagig auf die Seilrolle passt.</div><div><b>Lagerwiderstand: </b>Angabe des Lagerwiderstandes der Seilrolle in Newtonmeter. Damit kann ein Verlust des Antriebmomentes simuliert werden.&nbsp;</div><div><b>m</b>: Die Masse der Seilrolle in Kilogramm. Mit dieser Angabe wird die Trägheit der Seilrolle berechnet. Dabei wird angenommen, dass es sich um einen Vollzylinder handelt. Ein etwaiges Gewicht des Seiles wird in dieser Berechnung nicht betrachtet.&nbsp;</div><div><b>Durchmesserkomulation</b>: Eingabe eines Wertes im booleschen Format. Bei der Eingabe des Wertes \"False\", wird ein konstanter Windendurchmesser angenommen. Wird der Parameter auf \"True\" gesetzt wird in der Simulation berücksichtigt, dass der Durchmesser der Seiltrommel im Betrieb mit zunehmend aufgewickeltem Seil wächst. Dies hat direkte Auswirkungen auf die ausgegebene Seilposition und das Antriebsoment. Dabei ist zu beachten, dass in dieser Betriebsart die Position und das erforderliche Antriebsmoment nicht exakt, sondern aproximiert ausgegeben wird.&nbsp;<span style=\"font-family: 'MS Shell Dlg 2', serif;\">Bei einer
exakten Ausgabe würde das erforderliche Antriebsmoment mit den Lagen der
Seiltrommel wachsen. Die Geschwindigkeit der Seilposition würde bei jeder neuen
Seillage sprunghaft ansteigen. In der Betriebsart \"Durchmesserkomulation\"
wächst die Seilgeschwindigkeit und das erforderliche Antriebsmoment ab der
zweiten Seillage kontinuierlich.</span></div>




<!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
 </o:OfficeDocumentSettings>
</xml><![endif]-->


<!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:View>Normal</w:View>
  <w:Zoom>0</w:Zoom>
  <w:TrackMoves/>
  <w:TrackFormatting/>
  <w:HyphenationZone>21</w:HyphenationZone>
  <w:PunctuationKerning/>
  <w:ValidateAgainstSchemas/>
  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
  <w:DoNotPromoteQF/>
  <w:LidThemeOther>DE</w:LidThemeOther>
  <w:LidThemeAsian>X-NONE</w:LidThemeAsian>
  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:DontGrowAutofit/>
   <w:SplitPgBreakAndParaMark/>
   <w:EnableOpenTypeKerning/>
   <w:DontFlipMirrorIndents/>
   <w:OverrideTableStyleHps/>
  </w:Compatibility>
  <m:mathPr>
   <m:mathFont m:val=\"Cambria Math\"/>
   <m:brkBin m:val=\"before\"/>
   <m:brkBinSub m:val=\"&#45;-\"/>
   <m:smallFrac m:val=\"off\"/>
   <m:dispDef/>
   <m:lMargin m:val=\"0\"/>
   <m:rMargin m:val=\"0\"/>
   <m:defJc m:val=\"centerGroup\"/>
   <m:wrapIndent m:val=\"1440\"/>
   <m:intLim m:val=\"subSup\"/>
   <m:naryLim m:val=\"undOvr\"/>
  </m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState=\"false\" DefUnhideWhenUsed=\"false\"
  DefSemiHidden=\"false\" DefQFormat=\"false\" DefPriority=\"99\"
  LatentStyleCount=\"375\">
  <w:LsdException Locked=\"false\" Priority=\"0\" QFormat=\"true\" Name=\"Normal\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" QFormat=\"true\" Name=\"heading 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 7\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 8\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 9\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 9\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 7\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 8\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 9\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footnote text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"header\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footer\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index heading\"/>
  <w:LsdException Locked=\"false\" Priority=\"35\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"caption\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"table of figures\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"envelope address\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"envelope return\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footnote reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"line number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"page number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"endnote reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"endnote text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"table of authorities\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"macro\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"toa heading\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"10\" QFormat=\"true\" Name=\"Title\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Closing\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Signature\"/>
  <w:LsdException Locked=\"false\" Priority=\"1\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"Default Paragraph Font\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Message Header\"/>
  <w:LsdException Locked=\"false\" Priority=\"11\" QFormat=\"true\" Name=\"Subtitle\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Salutation\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Date\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text First Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text First Indent 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Note Heading\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Block Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Hyperlink\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"FollowedHyperlink\"/>
  <w:LsdException Locked=\"false\" Priority=\"22\" QFormat=\"true\" Name=\"Strong\"/>
  <w:LsdException Locked=\"false\" Priority=\"20\" QFormat=\"true\" Name=\"Emphasis\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Document Map\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Plain Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"E-mail Signature\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Top of Form\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Bottom of Form\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal (Web)\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Acronym\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Address\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Cite\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Code\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Definition\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Keyboard\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Preformatted\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Sample\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Typewriter\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Variable\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal Table\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation subject\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"No List\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Contemporary\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Elegant\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Professional\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Subtle 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Subtle 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Balloon Text\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" Name=\"Table Grid\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Theme\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Placeholder Text\"/>
  <w:LsdException Locked=\"false\" Priority=\"1\" QFormat=\"true\" Name=\"No Spacing\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Revision\"/>
  <w:LsdException Locked=\"false\" Priority=\"34\" QFormat=\"true\"
   Name=\"List Paragraph\"/>
  <w:LsdException Locked=\"false\" Priority=\"29\" QFormat=\"true\" Name=\"Quote\"/>
  <w:LsdException Locked=\"false\" Priority=\"30\" QFormat=\"true\"
   Name=\"Intense Quote\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"19\" QFormat=\"true\"
   Name=\"Subtle Emphasis\"/>
  <w:LsdException Locked=\"false\" Priority=\"21\" QFormat=\"true\"
   Name=\"Intense Emphasis\"/>
  <w:LsdException Locked=\"false\" Priority=\"31\" QFormat=\"true\"
   Name=\"Subtle Reference\"/>
  <w:LsdException Locked=\"false\" Priority=\"32\" QFormat=\"true\"
   Name=\"Intense Reference\"/>
  <w:LsdException Locked=\"false\" Priority=\"33\" QFormat=\"true\" Name=\"Book Title\"/>
  <w:LsdException Locked=\"false\" Priority=\"37\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"Bibliography\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"TOC Heading\"/>
  <w:LsdException Locked=\"false\" Priority=\"41\" Name=\"Plain Table 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"42\" Name=\"Plain Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"43\" Name=\"Plain Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"44\" Name=\"Plain Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"45\" Name=\"Plain Table 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"40\" Name=\"Grid Table Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\" Name=\"Grid Table 1 Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\" Name=\"Grid Table 6 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\" Name=\"Grid Table 7 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\" Name=\"List Table 1 Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\" Name=\"List Table 6 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\" Name=\"List Table 7 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Mention\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Smart Hyperlink\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Hashtag\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Unresolved Mention\"/>
 </w:LatentStyles>
</xml><![endif]-->

<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
 {mso-style-name:\"Normale Tabelle\";
 mso-tstyle-rowband-size:0;
 mso-tstyle-colband-size:0;
 mso-style-noshow:yes;
 mso-style-priority:99;
 mso-style-parent:\"\";
 mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
 mso-para-margin-top:0cm;
 mso-para-margin-right:0cm;
 mso-para-margin-bottom:8.0pt;
 mso-para-margin-left:0cm;
 line-height:107%;
 mso-pagination:widow-orphan;
 font-size:11.0pt;
 font-family:\"Calibri\",sans-serif;
 mso-ascii-font-family:Calibri;
 mso-ascii-theme-font:minor-latin;
 mso-hansi-font-family:Calibri;
 mso-hansi-theme-font:minor-latin;
 mso-bidi-font-family:\"Times New Roman\";
 mso-bidi-theme-font:minor-bidi;
 mso-fareast-language:EN-US;}
</style>
<![endif]-->



<!--StartFragment-->



<p style=\"margin:0cm;margin-bottom:.0001pt\"><span style=\"font-family: 'MS Shell Dlg 2', serif;\">Wird die Masse
heruntergelassen, wird immer auch in der Betriebsart
\"Durchmesserkomulation\", ein konstanter Trommeldurchmesser
angenommen. Das heißt, dass die Durchmesserkomulation nur beachtet wird, wenn
das Seil aufgewickelt wird.<font size=\"4\"><o:p></o:p></font></span></p>

<!--EndFragment-->

<!--EndFragment--><div>&nbsp;<div><div><br></div><div><b>Hinweis:</b> Die Parameter in der Gruppe Geometrie werden nur in der Betriebsart mit aktivierter Durchmesserkomulation benötigt. Ist diese Betriebsart nicht aktiviert, werden die eingetragenen Werte nicht beachtet, sodass sie keinerlei Einfluss auf die Simulation haben.&nbsp;</div></div></div></div></body></html>"));
      end Seilwinde;

      model Seilwinde_Decke
  //Parameter
        parameter Modelica.SIunits.Diameter Durchmesser = 0.2 "Trommeldurchmesser" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Momentum Lagerwiderstand = 0.0 "[Nm]" annotation(
          Dialog(group = "Trägheit und Verlust"));
        parameter Modelica.SIunits.Diameter d = 0.05 "Seildurchmesser [m]" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length b = 0.4 "Windenbreite [m]" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Mass m = 10 "Masse der Seilwinde excl. Seil" annotation(
          Dialog(group = "Trägheit und Verlust"));
        parameter Boolean Durchmesserkomulation = false annotation(
          Dialog(group = "Betriebsarten"));
        //Konstanten
        constant Real Pi = 2 * Modelica.Math.asin(1.0);
        //Variablen
        Real d_Winde;
        Integer v;
        Real o, dmax, s;
        Real J_Rolle, v_Rolle;
        //Ports
        Flaschenzug.Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {58, 126}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {57, -119}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
        Flaschenzug.Ports.M_w m_w annotation(
          Placement(visible = true, transformation(origin = {-134, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-119, 1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
      equation
  if v - 1 >= 1 and Durchmesserkomulation == true then
//Berechnung des Windendurchmessers als lineare Funktion
          d_Winde = Durchmesser + s * d;
          dmax = Durchmesser + (o - 1) * d * 2;
          s = (-m_w.w / (2 * Pi)) / (b / d) - 1;
        else
//keine Durchmesserapproximation
          d_Winde = Durchmesser;
          dmax = Durchmesser;
          s = 0;
        end if;
//am Seil wirkende Kraft
        f_s.F = (m_w.M - Lagerwiderstand) / (d_Winde / 2) - J_Rolle * der(v_Rolle);
//Drehgeschwindigkeit der Rolle
        v_Rolle = der(f_s.s);
//Berechneung des Massenträgheits der Rolle unter Annahme eines massiven Zylinders.
        J_Rolle = 0.5 * m * (Durchmesser / 2) ^ 2;
//berechnet die Anzahl der Schichten +1
        v = floor(m_w.w / (2 * Pi) / (b / d));
        v = o;
//Ausgabe der Seilposition
        f_s.s = Pi * d_Winde * (m_w.w / (2 * Pi));
        annotation(
          choices(choice(redeclare lib2.Resistor Load(a = {2}) "..."), choice(redeclare Capacitor Load(L = 3) "...")),
          Icon(graphics = {Rectangle(origin = {-44, 25}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-56, 15}, {144, -65}}), Line(origin = {38.3208, -57.8465}, points = {{18, 97}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-17.8189, 3.16671}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {1.89746, 1.88313}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Line(origin = {21.9273, 3.10701}, points = {{-22, 39}, {18, -45}}, color = {255, 85, 0}, thickness = 1), Rectangle(origin = {-92, 10}, fillPattern = FillPattern.Solid, extent = {{-9, 70}, {9, -70}}), Rectangle(origin = {92, 8}, fillPattern = FillPattern.Solid, extent = {{-9, 70}, {9, -70}}), Rectangle(origin = {-13, 91}, rotation = -90, fillPattern = FillPattern.Solid, extent = {{-9, 114}, {41, -88}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body><b>Die Seilwinde</b>&nbsp;dient zur Umwandlung einer Drehbewegung in eine translatorische Bewegung. Durch die Bidirektionalität kann auch eine translatorische Bewegung in eine rotatorische Bewegung umgewandelt werden.&nbsp;<div><br></div><div>Das Modell besitzt zwei Ports: Ein für translatorische Bewegung (f_s) und einen für rotatorische Bewegung (m_w).<br><div><br></div><div>Folgende&nbsp;<b>Parameter</b>&nbsp;stehen zur Eingabe bereit:</div><div><br></div><div><b>Durchmesser:&nbsp;</b>Dieser Parameter beschreibt in der Einheit Meter den Durchmesser der Seiltrommel.</div><div><b>d</b>: Beschreibt den Durchmesser des Seiles in Metern. Da in der Bibliothek die Seildehnung nicht betrachtet wird, ist der Durchmesser des Seiles lastunabhängig und wird als konstant angenommen.</div><div><b>b</b>: Die Breite der Winde in Metern. Unter Berücksichtigung von d wird mit dieser Angabe in der Betriebsart Durchmesserkomulation berechnet, wieviele Umdrehungen das Seil einlagig auf die Seilrolle passt.</div><div><b>Lagerwiderstand:&nbsp;</b>Angabe des Lagerwiderstandes der Seilrolle in Newtonmeter. Damit kann ein Verlust des Antriebmomentes simuliert werden.&nbsp;</div><div><b>m</b>: Die Masse der Seilrolle in Kilogramm. Mit dieser Angabe wird die Trägkhit der Seilrolle berechnet. Dabei wird angenommen, dass es sich um einen Vollzylinder handelt. Ein etwaiges Gewicht des Seiles wird in dieser Berechnung nicht beachtet.&nbsp;</div><div><b>Durchmesserkomulation</b>: Eingabe eines Wertes im booleschen Format. Bei der Eingabe des Wetes \"False\", wird ein konstanter Windendurchmesser angenommen. Wird der Parameter auf \"True\" gesetzt wird in der Simulation berücksichtigt, dass der Durchmesser der Seiltrommel im Betrieb mit zunehmend aufgewickeltem Seil wächst. Das hat direkte Auswirkungen auf die ausgegebene Seilposition. Dabei ist zu beachten, dass in dieser Betriebsart die Position nicht exakt, sondern aproximiert ausgegeben wird.&nbsp;&nbsp;<span style=\"font-family: 'MS Shell Dlg 2', serif;\">Bei einer exakten Ausgabe würde das erforderliche Antriebsmoment mit den Lagen der Seiltrommel wachsen. Die Geschwindigkeit der Seilposition würde bei jeder neuen Seillage sprunghaft ansteigen.&nbsp;</span><span style=\"font-family: 'MS Shell Dlg 2', serif;\"><b><u>&nbsp;</u></b>In der Betriebsart \"Durchmesserkomulation\" wächst die Seilgeschwindigkeit und das erforderliche Antriebsmoment ab der zweiten Seillage kontinuierlich.</span></div><p style=\"margin: 0cm 0cm 0.0001pt;\"><span style=\"font-family: 'MS Shell Dlg 2', serif;\">Wird die Masse heruntergelassen, wird immer auch in der Betriebsart \"Druchmesserkomulation\", ein konstanter Trommeldurchmesser angenommen. Das heißt, dass die Durchmesserkomulation nur beachtet wird, wenn das Seil aufgewickelt wird.</span></p><div>&nbsp;<div><div><br></div><div><b>Hinweis:</b>&nbsp;Die Parameter in der Gruppe Geometrie werden nur in der Betriebsart mit aktivierter Durchmesserkomulation benötigt. Ist diese Betriebsart nicht aktiviert, werden die eingetragenen Werte nicht beachtet, sodass sie keinerlei Einfluss auf die Simulation haben.&nbsp;</div></div></div></div></body></html>"));
      end Seilwinde_Decke;
  annotation(
        Icon(graphics = {Rectangle(origin = {-1, -1}, fillColor = {140, 140, 140}, fillPattern = FillPattern.Solid, extent = {{-99, 41}, {101, -41}}), Line(origin = {-25.7439, -1.2561}, points = {{-22, 41}, {22, -41}, {22, -41}}, color = {213, 0, 0}, thickness = 3), Line(origin = {-2.42683, -0.475612}, points = {{-22, 41}, {22, -41}, {22, -41}}, color = {213, 0, 0}, thickness = 3), Line(origin = {23.4512, -0.463417}, points = {{-22, 41}, {22, -41}, {22, -41}}, color = {213, 0, 0}, thickness = 3), Line(origin = {36.2439, -0.731709}, points = {{20, 75}, {22, -41}, {22, -41}}, color = {213, 0, 0}, thickness = 3)}),
        Documentation(info = "<html><head></head><body>Die Seilwinden dienen zur Umwandlung einer Drehbewegung in eine translatorische Bewegung.<div><br></div><div>Die hierin enthaltenen Seilwinden unterscheiden sich nur optisch, um eine etwaige Spiegelung im Simulationsmodell vorzubeugen.</div></body></html>"));
    end Seilwinden;

    package Flaschenzuege
      model Flaschenzug_Modell
        //Parametereingabe
        parameter Integer n = 3 "Anzahl der Rollen" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length s = 3 "Anfangslänge" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length Sa = 0 "Sensorabstand" annotation(
          Dialog(group = "Elektrisch"));
        parameter Modelica.SIunits.Angle Zugwinkel = 45 "Zugwinkel" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Mass Flaschengewicht_unten = 2 "[kg]" annotation(
          Dialog(group = "Flaschengewicht"));
        parameter Modelica.SIunits.Mass Flaschengewicht_oben = 2 "[kg]" annotation(
          Dialog(group = "Flaschengewicht"));
        //Konstante
        Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
        constant Real Pi = 2 * Modelica.Math.asin(1.0);
        constant Real Hysteresis = 0.01;
        //Geschwindigkeit der Flaschen
        Real v, v_oben;
        //Flaschengewicht und Beschleunigungskraft
        Real Fges;
        //Umrechnung Zugwinkel von Grad in Rad/s
        Real Zwinkel;
        //Ports
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
//Signal auf true setzten, wenn Flaschenzug ganz zusammengefahren
          boolOut1 = true;
        elseif v < 0 and f_s.s >= f_s1.s - Sa - Hysteresis then
//Hysterese
          boolOut1 = true;
        else
          boolOut1 = false;
        end if;
//Einfluss der Massenträgheit der unteren Flasche aud die Gesamtkraft
        Fges = f_s.F - Flaschengewicht_unten * g - Flaschengewicht_unten * der(v) - Flaschengewicht_oben * der(v_oben);
//an der unteren Flasche wirkende Kraft
        f_s2.F = Fges / n;
//Gesch. der oberen Flasche
        v_oben = der(f_s1.s);
//Gesch. der unteren Flasche
        v = der(f_s.s);
//Winkelumrechnung
        Zwinkel = Zugwinkel * (180 / Pi);
//Pos der unteren Flasche
        -f_s.s = (-f_s1.s) + s + f_s2.s / n;
//Kraft an oberer Flasche
        f_s1.F = f_s.F + cos(Zwinkel) * f_s2.F - Flaschengewicht_unten * g + Flaschengewicht_oben * g;
        annotation(
          Icon(graphics = {Rectangle(origin = {-3, -65}, fillPattern = FillPattern.Solid, extent = {{-1, 3}, {9, -35}}), Rectangle(origin = {-3, 69}, fillPattern = FillPattern.Solid, extent = {{-1, 31}, {9, -47}}), Line(origin = {-69.18, 25}, points = {{55, 42}, {-31, -56}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-21.89, -45.81}, points = {{11, 57}, {9, -37}}, color = {255, 85, 0}, thickness = 1), Line(origin = {21.8499, 44.31}, points = {{0, 9}, {-8, -127}}, color = {255, 85, 0}, thickness = 1), Line(origin = {43.12, -11.0249}, points = {{-31, 20}, {-41, -50}}, color = {255, 85, 0}, thickness = 1), Ellipse(origin = {2, 51}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-24, 23}, {20, -21}}, endAngle = 360), Ellipse(origin = {4, -84}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-18, 16}, {12, -14}}, endAngle = 360), Ellipse(origin = {1, 9}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-13, 15}, {13, -11}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body>Der Flaschenzug bietet analog zum Getriebe im Rotatorischen eine Untersetzung ins Translatorische.&nbsp;<div><br></div><div><b>Ports</b></div><div>Das Modell besitzt drei F_s Ports, über diese Ports können bidirektional die Kraft und die Position übergeben werden.&nbsp;<br>




<!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
 </o:OfficeDocumentSettings>
</xml><![endif]-->


<!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:View>Normal</w:View>
  <w:Zoom>0</w:Zoom>
  <w:TrackMoves/>
  <w:TrackFormatting/>
  <w:HyphenationZone>21</w:HyphenationZone>
  <w:PunctuationKerning/>
  <w:ValidateAgainstSchemas/>
  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
  <w:DoNotPromoteQF/>
  <w:LidThemeOther>DE</w:LidThemeOther>
  <w:LidThemeAsian>X-NONE</w:LidThemeAsian>
  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:DontGrowAutofit/>
   <w:SplitPgBreakAndParaMark/>
   <w:EnableOpenTypeKerning/>
   <w:DontFlipMirrorIndents/>
   <w:OverrideTableStyleHps/>
  </w:Compatibility>
  <m:mathPr>
   <m:mathFont m:val=\"Cambria Math\"/>
   <m:brkBin m:val=\"before\"/>
   <m:brkBinSub m:val=\"&#45;-\"/>
   <m:smallFrac m:val=\"off\"/>
   <m:dispDef/>
   <m:lMargin m:val=\"0\"/>
   <m:rMargin m:val=\"0\"/>
   <m:defJc m:val=\"centerGroup\"/>
   <m:wrapIndent m:val=\"1440\"/>
   <m:intLim m:val=\"subSup\"/>
   <m:naryLim m:val=\"undOvr\"/>
  </m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState=\"false\" DefUnhideWhenUsed=\"false\"
  DefSemiHidden=\"false\" DefQFormat=\"false\" DefPriority=\"99\"
  LatentStyleCount=\"375\">
  <w:LsdException Locked=\"false\" Priority=\"0\" QFormat=\"true\" Name=\"Normal\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" QFormat=\"true\" Name=\"heading 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 7\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 8\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 9\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 9\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 7\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 8\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 9\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footnote text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"header\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footer\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index heading\"/>
  <w:LsdException Locked=\"false\" Priority=\"35\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"caption\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"table of figures\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"envelope address\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"envelope return\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footnote reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"line number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"page number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"endnote reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"endnote text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"table of authorities\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"macro\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"toa heading\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"10\" QFormat=\"true\" Name=\"Title\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Closing\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Signature\"/>
  <w:LsdException Locked=\"false\" Priority=\"1\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"Default Paragraph Font\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Message Header\"/>
  <w:LsdException Locked=\"false\" Priority=\"11\" QFormat=\"true\" Name=\"Subtitle\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Salutation\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Date\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text First Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text First Indent 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Note Heading\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Block Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Hyperlink\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"FollowedHyperlink\"/>
  <w:LsdException Locked=\"false\" Priority=\"22\" QFormat=\"true\" Name=\"Strong\"/>
  <w:LsdException Locked=\"false\" Priority=\"20\" QFormat=\"true\" Name=\"Emphasis\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Document Map\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Plain Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"E-mail Signature\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Top of Form\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Bottom of Form\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal (Web)\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Acronym\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Address\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Cite\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Code\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Definition\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Keyboard\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Preformatted\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Sample\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Typewriter\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Variable\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal Table\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation subject\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"No List\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Contemporary\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Elegant\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Professional\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Subtle 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Subtle 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Balloon Text\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" Name=\"Table Grid\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Theme\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Placeholder Text\"/>
  <w:LsdException Locked=\"false\" Priority=\"1\" QFormat=\"true\" Name=\"No Spacing\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Revision\"/>
  <w:LsdException Locked=\"false\" Priority=\"34\" QFormat=\"true\"
   Name=\"List Paragraph\"/>
  <w:LsdException Locked=\"false\" Priority=\"29\" QFormat=\"true\" Name=\"Quote\"/>
  <w:LsdException Locked=\"false\" Priority=\"30\" QFormat=\"true\"
   Name=\"Intense Quote\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"19\" QFormat=\"true\"
   Name=\"Subtle Emphasis\"/>
  <w:LsdException Locked=\"false\" Priority=\"21\" QFormat=\"true\"
   Name=\"Intense Emphasis\"/>
  <w:LsdException Locked=\"false\" Priority=\"31\" QFormat=\"true\"
   Name=\"Subtle Reference\"/>
  <w:LsdException Locked=\"false\" Priority=\"32\" QFormat=\"true\"
   Name=\"Intense Reference\"/>
  <w:LsdException Locked=\"false\" Priority=\"33\" QFormat=\"true\" Name=\"Book Title\"/>
  <w:LsdException Locked=\"false\" Priority=\"37\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"Bibliography\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"TOC Heading\"/>
  <w:LsdException Locked=\"false\" Priority=\"41\" Name=\"Plain Table 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"42\" Name=\"Plain Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"43\" Name=\"Plain Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"44\" Name=\"Plain Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"45\" Name=\"Plain Table 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"40\" Name=\"Grid Table Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\" Name=\"Grid Table 1 Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\" Name=\"Grid Table 6 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\" Name=\"Grid Table 7 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\" Name=\"List Table 1 Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\" Name=\"List Table 6 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\" Name=\"List Table 7 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Mention\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Smart Hyperlink\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Hashtag\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Unresolved Mention\"/>
 </w:LatentStyles>
</xml><![endif]-->

<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
 {mso-style-name:\"Normale Tabelle\";
 mso-tstyle-rowband-size:0;
 mso-tstyle-colband-size:0;
 mso-style-noshow:yes;
 mso-style-priority:99;
 mso-style-parent:\"\";
 mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
 mso-para-margin-top:0cm;
 mso-para-margin-right:0cm;
 mso-para-margin-bottom:8.0pt;
 mso-para-margin-left:0cm;
 line-height:107%;
 mso-pagination:widow-orphan;
 font-size:11.0pt;
 font-family:\"Calibri\",sans-serif;
 mso-ascii-font-family:Calibri;
 mso-ascii-theme-font:minor-latin;
 mso-hansi-font-family:Calibri;
 mso-hansi-theme-font:minor-latin;
 mso-bidi-font-family:\"Times New Roman\";
 mso-bidi-theme-font:minor-bidi;
 mso-fareast-language:EN-US;}
</style>
<![endif]-->



<!--StartFragment-->

<p class=\"MsoNormal\"><span style=\"font-size: 9pt; line-height: 107%; font-family: 'MS Shell Dlg 2', sans-serif;\">Ein boolescher Output dient zur
Ausgabe eines Sensorsignals. Der Sensor detektiert, ob sich die Masse bei oder
oberhalb einer bestimmten Höhe (s. Parameter)&nbsp;befindet. Detektiert der
Sensor die Masse, so wird am booleschen Ausgang ein&nbsp;</span><i>true&nbsp;</i>ausgegeben.
Ist die Masse unterhalb dieser festgelegten Höhe, so wird&nbsp;<i>false</i>&nbsp;ausgegeben.
Geringe Höhenabweichungen der Masse können ein ständiges Ein- und Ausschalten
des Motors verursachen. Um dies zu verhindern ist der Sensor mit einer
Hysterese versehen (siehe Konstanten).<o:p></o:p></p>

<!--EndFragment--></div><div><br></div><div>Folgende<b> Parameter</b> stehen bereit:&nbsp;</div><div><b>n</b> (Anzahl der Rollen): n beschreibt das Übersetzungsverhältniss des Flaschenzugs. Für n können nur ganzzahlige Werte größer 1 eingegeben werden. Grundlegend ist die an der unteren Flasche (f_s) wirkende Kraft n mal höher als die am f_s2 -Port wirkende Kraft. Störgrößen, wie die Trägheit der unteren Flasche wirken sich auf diese grundlegende Gleichung aus. Beim Weg verhält sich der Zusammenhang ähnlich: Die Positionsänderung &nbsp;der unteren Flasche ist n mal kleiner als die Positionsänderung des f_s2 -Ports. Die Verringerung von n um 1 ergibt sich aus der Zugrichtung &nbsp;nach oben, wodurch eine Rolle nicht benutzt wird. Der Startwert ergibt sich aus der Position der oberen Flasche - der Anfangslänge des Flaschenzugs s.&nbsp;</div><div><b>s</b> (Anfangslänge): Die Anfangslänge beschreibt den Abstand der oberen zur unteren Flasche. Meist wird im Modell die obere Flasche mit einem Fixpunkt verbunden, sodass sich die Position der unteren Flasche aus der Höhe des Fixpunktes - s ergibt.&nbsp;</div><div><b>Zugwinkel: </b>Der Zugwinkel in rad wird im Modell dafür verwendet, die am f_s1-Port (obere Flasche) auftretenden Kräfte in vertikale Richtung zu berechnen. Die horizontal wirkenden Kräfte werden im Modell vernachlässigt.</div><div><b>Sa </b>(Sensorabstand): Der Sensorabstand in Metern gibt den Abstand des Positionssensors bis zur oberen Flasche an. Die Funktionsweise des Sensors ist bei den Portbeschreibungen zu finden.&nbsp;</div><div><div><b>Flaschengewicht_unten</b>: Dieser Parameter gibt das Flaschengewicht der unteren Flasche an. Die Angabe wird im Modell benutzt um die Trägheit und das Leergewicht des Flaschenzuges zu kennen.&nbsp;</div><div><b style=\"font-size: 12px;\">Flaschengewicht_oben</b><span style=\"font-size: 12px;\">: Dieser Parameter gibt das Flaschengewicht der oberen Flasche an.&nbsp;</span><span style=\"font-size: 12px;\">&nbsp;</span><span style=\"font-size: 12px;\">Die Angabe wird im Modell benutzt um die Trägheit und das Leergewicht des Flaschenzuges zu kennen.</span></div></div><div><br></div></body></html>"));
      end Flaschenzug_Modell;

      model Flaschenzug_Modell_b
        //Parametereingabe
        parameter Integer n = 2 "Anzahl der Rollen" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length s = 3 "Anfangslänge" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Length Sa = 0 "Sensorabstand" annotation(
          Dialog(group = "Elektrisch"));
        parameter Modelica.SIunits.Angle Zugwinkel = 45 "Zugwinkel" annotation(
          Dialog(group = "Geometrie"));
        parameter Modelica.SIunits.Mass Flaschengewicht_unten = 2 "[kg]" annotation(
          Dialog(group = "Flaschengewicht"));
        parameter Modelica.SIunits.Mass Flaschengewicht_oben = 2 "[kg]" annotation(
          Dialog(group = "Flaschengewicht"));
        //Konstante
        Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
        constant Real Pi = 2 * Modelica.Math.asin(1.0);
        constant Real Hysteresis = 0.01;
        //Geschwindigkeit der Flaschen
        Real v,v_oben;
        //Flaschengewicht und Beschleunigungskraft
        Real Fges;
        //Umrechnung Zugwinkel von Grad in Rad/s
        Real Zwinkel;
        //Ports
        Flaschenzug.Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {2, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {1, -115}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
        Flaschenzug.Ports.F_s f_s1 annotation(
          Placement(visible = true, transformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {1, 113}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
        Flaschenzug.Ports.F_s f_s2 annotation(
          Placement(visible = true, transformation(origin = {-114, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-114, 56}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
        Flaschenzug.Ports.BoolOut boolOut1 annotation(
          Placement(visible = true, transformation(origin = {-32, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {17, 85}, extent = {{11, -11}, {-11, 11}}, rotation = 0)));
      equation
  if f_s.s + Sa >= f_s1.s then
//Signal auf true setzten, wenn Flaschenzug ganz zusammengefahren
          boolOut1 = true;
        elseif v < 0 and f_s.s >= f_s1.s - Sa - Hysteresis then
//Hysterese
          boolOut1 = true;
        else
          boolOut1 = false;
        end if;
//Einfluss der Massenträgheit der unteren Flasche aud die Gesamtkraft
        Fges = f_s.F - Flaschengewicht_unten * g - Flaschengewicht_unten * der(v) - Flaschengewicht_oben * der(v_oben);
//an der unteren Flasche wirkende Kraft
        f_s2.F = Fges / (n + 1);
//Gesch. der oberen Flasche
        v_oben = der(f_s1.s);
//Gesch. der unteren Flasche
        v = der(f_s.s);
//Winkelumrechnung
        Zwinkel = Zugwinkel * (180 / Pi);
//Pos der unteren Flasche
        -f_s.s = (-f_s1.s) + s + f_s2.s / (n + 1);
//Kraft an oberer Flasche
        f_s1.F = f_s.F + cos(Zwinkel) * f_s2.F - Flaschengewicht_unten * g + Flaschengewicht_oben * g;
        annotation(
          Icon(graphics = {Rectangle(origin = {-3, -65}, fillPattern = FillPattern.Solid, extent = {{-1, 39}, {9, -35}}), Rectangle(origin = {-3, 69}, fillPattern = FillPattern.Solid, extent = {{-1, 31}, {9, -31}}), Line(origin = {-68.89, 24.71}, points = {{55, -114}, {-31, 32}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-20.4565, 11.2428}, points = {{7, 45}, {9, -37}}, color = {255, 85, 0}, thickness = 1), Line(origin = {28.73, 52.62}, points = {{-14, 9}, {-8, -127}}, color = {255, 85, 0}, thickness = 1), Line(origin = {54.0145, 23.3787}, points = {{-53, 14}, {-41, -50}}, color = {255, 85, 0}, thickness = 1), Ellipse(origin = {2, -75}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-24, 23}, {20, -21}}, endAngle = 360), Ellipse(origin = {4, 56}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-18, 16}, {12, -14}}, endAngle = 360), Ellipse(origin = {1, -27}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-13, 15}, {13, -11}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\"><strong><u>Information</u></strong></p><div class=\"textDoc\"><p style=\"font-family: 'Courier New'; font-size: 12px;\"></p></div><div class=\"htmlDoc\">Der Flaschenzug bietet analog zum Getriebe im Rotatorischen eine Untersetzung in das Translatorische.&nbsp;<div><br></div><div><b>Ports</b></div><div>Das Modell besitzt drei F_s Prots über diese bidirektional Kraft und Position übergeben werden kann.&nbsp;</div><div><span style=\"font-size: 9pt; line-height: 107%; font-family: 'MS Shell Dlg 2', sans-serif;\">Ein boolescher Output dient zur
Ausgabe eines Sensorsignals. Der Sensor detektiert, ob sich die Masse bei oder
oberhalb einer bestimmten Höhe (s. Parameter)&nbsp;befindet. Detektiert der
Sensor die Masse, so wird am booleschen Ausgang ein&nbsp;</span><i>true</i>&nbsp;ausgegeben.
Ist die Masse unterhalb dieser festgelegten Höhe, so wird&nbsp;<i>false</i>&nbsp;ausgegeben.
Geringe Höhenabweichungen der Masse können ein ständiges Ein- und Ausschalten
des Motors verursachen. Um dies zu verhindern ist der Sensor mit einer
Hysterese versehen (siehe Konstanten).</div><div><p class=\"MsoNormal\"><o:p></o:p></p>

<!--EndFragment--><p class=\"MsoNormal\"><o:p></o:p></p>

<!--EndFragment--></div><div><br></div><div>Folgeende<b>&nbsp;Parameter</b>&nbsp;stehen bereit:&nbsp;</div><div><b>n</b>&nbsp;(Anzahl der Rollen): Daraus wird modellintern das Übersetzungsverhältniss des Flaschenzugs berechnet. Für n können nur ganzzahlige Werte größer 1 eingegeben werden. Grundlegend ist die an der unteren Flasche (f_s) wirkedne Kraft n mal höher als die am f_s2 -Port wirkende Kraft. Störgrößen, wie die Trägheit der unteren Flasche wirken sich auf diese grundlegende Gleichung aus. Beim Weg verhält sich der Zusammenhang ähnlich: die Positionsänderung &nbsp;der unteren Flashe n+1 mal kleiner als die Positionsänderung des f_s2 -Ports. Der Startwert ergibt sich aus der Position der oberen Flasche - der Anfangslänge des Flaschenzugs s.&nbsp;</div><div><b>s</b>&nbsp;(Anfangslänge): Die Anfangslänge beschreibt den Abstand der oberen zur unteren Flasche. Meist wird im Modell die obere Flasche mit einem Fixpunkt verbunden, sodass sich die Position der unteren Flasche aus der Höhe des Fixpunktes - s ergibt.&nbsp;</div><div><b>Zugwinkel:&nbsp;</b>Der Zugwinkel in Rad wird im Modell dafür verwendet die am f_s1-Port (obere Flasche) auftretenden Kräfte in vertikale Richtung zu berechnen. Die horizontal Wirkenden Kräfte werden im Modell vernachlässigt.</div><div><b>Sa&nbsp;</b>(Sensorabstand): Der Sensorabstand in Metern gibt den Abstand des Positionnssensors bis zur oberen Flasche an. Die Funktionsweise des Swnsors ist bei den Portbeschreibungen zu finden.&nbsp;</div><div><b>Flaschengewicht_unten</b>: Dieser Parameter gibt das Flaschengewicht der unteren Flasche an. Die Angabe wird im Modell benutzt um die Trägheit und das Leergewicht des Flaschenzuges zu kennen.&nbsp;</div><div><b style=\"font-size: 12px;\">Flaschengewicht_oben</b><span style=\"font-size: 12px;\">: Dieser Parameter gibt das Flaschengewicht der oberen Flasche an.&nbsp;</span><span style=\"font-size: 12px;\">Die Angabe wird im Modell benutzt um die Trägheit und das Leergewicht des Flaschenzuges zu kennen.</span></div></div></body></html>"));
      end Flaschenzug_Modell_b;
    annotation(
        Icon(graphics = {Rectangle(origin = {-3, -65}, fillPattern = FillPattern.Solid, extent = {{-1, 3}, {9, -35}}), Rectangle(origin = {-3, 69}, fillPattern = FillPattern.Solid, extent = {{-1, 31}, {9, -47}}), Line(origin = {-69.18, 25}, points = {{55, 42}, {-31, -56}}, color = {255, 85, 0}, thickness = 1), Line(origin = {-21.89, -45.81}, points = {{11, 57}, {9, -37}}, color = {255, 85, 0}, thickness = 1), Line(origin = {21.8499, 44.31}, points = {{0, 9}, {-8, -127}}, color = {255, 85, 0}, thickness = 1), Line(origin = {43.12, -11.0249}, points = {{-31, 20}, {-41, -50}}, color = {255, 85, 0}, thickness = 1), Ellipse(origin = {2, 51}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-24, 23}, {20, -21}}, endAngle = 360), Ellipse(origin = {4, -84}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-18, 16}, {12, -14}}, endAngle = 360), Ellipse(origin = {1, 9}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-13, 15}, {13, -11}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
        Documentation(info = "<html><head></head><body><div>Das Flaschenzugmodell ist das zentrale Element in der Flaschenzugbibliothek.&nbsp;</div><div><br></div><div>Die in dem Package enthaltenen Flaschenzüge unterscheiden sich in der Zugrichtung des Zugseils (nicht zu verwechseln mit der unteren Flasche).&nbsp;</div><div><br></div><div>Beim Modell b ist die Zugrichtung nach oben gerichtet. Dies hat die Auswirkung, dass die Übersetzung zur unteren Flasche um eins verringert wird.</div><div><br></div><br><br></body></html>"));
    end Flaschenzuege;

    package Massen
      model Masse
        //Masse
        parameter Modelica.SIunits.Mass m = 40 annotation(
          Dialog(group = "Masse"));
        //Erdbeschleunigung
        Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
        //Variable Beschleunigung, Geschwindigkeit
        Real a, v;
        Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      equation
//Kraft am Kraft-Weg-Prot, unter berücksichtigung der Trägheit
        f_s.F = m * g + m * a;
//Berechnung der Beschleunigungs-Variable
        der(v) = a;
//Berechnung der Geschwindigkeits-Variable
        der(f_s.s) = v;
        annotation(
          Icon(graphics = {Polygon(fillColor = {102, 102, 102}, fillPattern = FillPattern.Solid, points = {{-100, 60}, {-60, 100}, {60, 100}, {100, 60}, {100, -100}, {-100, -100}, {-100, -84}, {-100, 60}}), Text(origin = {-35, 33}, lineColor = {221, 221, 221}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid, extent = {{-27, 23}, {97, -77}}, textString = "Masse")}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body>Die<b> Masse </b>dient im Modell meist als Objekt, welches bewegt werden soll. In der Simulation wird die Trägheit mit berücksichtigt.&nbsp;<div><b>Parametrierbar</b> ist hierbei allein die Masse in Kilogramm.&nbsp;</div><div><br></div><div>Am <b>Kraft-Weg-Port</b> können Kräfte und Positionen bidirektional übergeben werden.</div></body></html>"));
      end Masse;

      model Bierkasten
       //Masse
        parameter Modelica.SIunits.Mass m = 40 annotation(
          Dialog(group = "Masse"));
       //Erdbeschleunigung
        Modelica.SIunits.Acceleration g = Modelica.Constants.g_n;
        //Variable Beschleunigung, Geschwindigkeit
        Real a, v;
        Ports.F_s f_s annotation(
          Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      equation
//Kraft am Kraft-Weg-Prot, unter Berücksichtigung der Trägheit
        f_s.F = m * g + m * a;
//Berechnung der Beschleunigungs-Variable
        der(v) = a;
//Berechnung der Geschwindigkeits-Variable
        der(f_s.s) = v;
        annotation(
          Icon(graphics = {Rectangle(fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {3, 41}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-77, 19}, {77, -19}}), Text(origin = {6, -22}, lineColor = {255, 255, 255}, extent = {{-74, 18}, {74, -18}}, textString = "Chiemseer"), Rectangle(origin = {6, -38}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-70, 2}, {70, -2}}), Text(origin = {-20, -41}, lineColor = {255, 255, 255}, extent = {{-6, 5}, {54, -19}}, textString = "Rosenheimer"), Text(origin = {2, -63}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, extent = {{-60, 7}, {60, -7}}, textString = "Spezialbrauerei"), Polygon(origin = {-53, 41}, fillColor = {136, 68, 0}, fillPattern = FillPattern.Solid, points = {{-7, 19}, {5, 19}, {9, -1}, {21, -19}, {-21, -19}, {-9, -1}, {-9, -1}, {-7, 19}}), Polygon(origin = {-13, 41}, fillColor = {136, 68, 0}, fillPattern = FillPattern.Solid, points = {{-7, 19}, {5, 19}, {9, -1}, {21, -19}, {-21, -19}, {-9, -1}, {-9, -1}, {-7, 19}}), Polygon(origin = {23, 41}, fillColor = {136, 68, 0}, fillPattern = FillPattern.Solid, points = {{-7, 19}, {5, 19}, {9, -1}, {21, -19}, {-21, -19}, {-9, -1}, {-9, -1}, {-7, 19}}), Polygon(origin = {59,41}, fillColor = {136, 68, 0}, fillPattern = FillPattern.Solid, points = {{-7, 19}, {5, 19}, {9, -1}, {21, -19}, {-21, -19}, {-9, -1}, {-9, -1}, {-7, 19}})}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">Die</span><b style=\"font-size: 12px;\">&nbsp;Masse&nbsp;</b><span style=\"font-size: 12px;\">dient im Modell meist als Objekt, welches bewegt werden soll. In der Simulation wird die Trägheit mit berücksichtigt.&nbsp;</span><div style=\"font-size: 12px;\"><b>Parametrierba</b>r ist hierbei allein die Masse in Kilogramm.&nbsp;</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Am&nbsp;<b>Kraft-Weg-Port</b>&nbsp;können Kräfte und Positionen bidirektional übergeben werden.</div></body></html>"));
      end Bierkasten;
    annotation(
        Icon(graphics = {Polygon(fillColor = {102, 102, 102}, fillPattern = FillPattern.Solid, points = {{-100, 60}, {-60, 100}, {60, 100}, {100, 60}, {100, -100}, {-100, -100}, {-100, -84}, {-100, 60}}), Text(origin = {-35, 33}, lineColor = {221, 221, 221}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid, extent = {{-27, 23}, {97, -77}}, textString = "Masse")}, coordinateSystem(initialScale = 0.1)),
        Documentation(info = "<html><head></head><body>Die Massenbibliothek beinhaltet Massenmodelle, die sich ausschließlich <b>optisch</b> voneinander unterscheiden.</body></html>"));
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
          Documentation(info = "<html><head></head><body><!--StartFragment-->Der Motor ist eine permanenterregte Gleichstrommaschine mit Grafitbürsten, welche einphasig betrieben wird.<div>Die voreingestelllte Bemessungsspannung beträgt U<sub>a rat&nbsp;</sub>= 48V.</div><div>Die Gleichstromaschine lässt sich sowohl motorisch als auch generatorisch betreiben.</div><div>Weiterhin ist die Drehrichtung des Motors variabel. Sie ist über das Vorzeichen der Bemessungsspannung einstellbar.</div><div><br></div><div><b>Positive Bemessungspannung</b></div><div>*<span class=\"Apple-tab-span\" style=\"white-space: pre;\">	</span>Lastmoment positiv: motorischer Betrieb</div><div>*<span class=\"Apple-tab-span\" style=\"white-space: pre;\">	</span>Lastmoment negativ: generatorischer Betrieb</div><div><br></div><div><div><b>Negative Bemessungspannung</b></div><div>*<span class=\"Apple-tab-span\" style=\"white-space: pre;\">	</span>Lastmoment positiv: generatorischer Betrieb</div><div>*<span class=\"Apple-tab-span\" style=\"white-space: pre;\">	</span>Lastmoment negativ: motorischer Betrieb</div></div><div><br></div><div>Im motorischen Betrieb wird elektrische Energie in mechanische Energie umgewandelt.</div><div>Im generatorischen Betrieb findet eine Umwandlung von mechanischer in elektrische Energie statt.</div><div><br></div><div><div><b>Parametrierbarkeit in der Visualisierung</b></div><div>In der Visualisierung lassen sich die Motordaten an die entsprechenden Anforderungen anpassen. Damit lassen sich verschiedene permanenterregte Gleichstommaschinen mit und ohne Bürstenspannungsabfällen simulieren.&nbsp;Die Gleichstommaschine ist mit den nachfolgenden Parametern voreingestellt:</div><div><br></div><div>Bürstenspannungsabfall: 2<sub>Ub&nbsp;</sub>= 0.8&nbsp;V</div><div>Ankerwiderstand: R<sub>a&nbsp;</sub>=&nbsp;0.608&nbsp;Ohm</div><div>Ankerinduktivität: L<sub>a&nbsp;</sub>=&nbsp;423 µH</div><div>Gesamtes Massenträgheitsmoment: J<sub>tot&nbsp;</sub>= 0.018&nbsp;kgm<sup>2</sup></div><div>Drehmomentkonstante: k<sub>t</sub>&nbsp;= 0.091534&nbsp;Nm/A</div><div>Reibungskonstante: C<sub>f</sub>&nbsp;= 0 Nms</div><div>Ventilationskonstante: C<sub>v</sub>&nbsp;= 0.000005 Nms<sup>2</sup></div></div><div><sup><font size=\"3\"><br></font></sup></div><div><div><b>Auslegung des Motors:</b></div><div>Basierend auf den voreingestellten Parametern ist der Motor wie folgt ausgelegt:</div><div><br></div><div>Moment an der Welle: M<sub>sh&nbsp;</sub>= 0-7 Nm</div><div><div>Umdrehung pro min: n = 0-5000 min<sup>-1</sup></div></div></div><div>Anlaufdrehmoment: M<sub>sh su&nbsp;</sub>= 7.1 Nm</div><div>Anlaufstrom: I<sub>a su</sub>&nbsp;= 77.6 A</div><!--EndFragment--></body></html>"));
      end Motor;

      model Getriebe
        //Paramtereingabe
        parameter Real Uebersetzung = 2 "Übersetzung" annotation(
          Dialog(group = "Getriebeparameter"));
        parameter Modelica.SIunits.Efficiency Wirkungsgrad = 1 "Wirkungsgrad" annotation(
          Dialog(group = "Getriebeparameter"));
        parameter Modelica.SIunits.MomentOfInertia J_Eingangswelle = 0.00 annotation(
          Dialog(group = "Trägheiten"));
        parameter Modelica.SIunits.MomentOfInertia J_Ausgangsewelle = 0.00 annotation(
          Dialog(group = "Trägheiten"));
        //Variablen der Wellengeschwindigkeiten
        Real v_w_ein;
        Real v_w_aus;
        //Ports
        Flaschenzug.Ports.M_w m_w annotation(
          Placement(visible = true, transformation(origin = {110, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {119, -29}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
        Flaschenzug.Ports.M_w m_w1 annotation(
          Placement(visible = true, transformation(origin = {-124, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
      equation
//Berechnung Ausgangsmoment
        m_w.M = m_w1.M * Uebersetzung * Wirkungsgrad - (v_w_aus * J_Ausgangsewelle - v_w_ein * J_Eingangswelle);
//Berechnug Winkel der Ausgabewelle
        -m_w.w = m_w1.w / Uebersetzung;
//Geschwindigkeit der Eingangswelle
        v_w_ein = der(m_w1.w);
//Geschwindigkeit der Ausgangswelle
        v_w_aus = der(m_w.w);
        annotation(
          Icon(graphics = {Rectangle(origin = {-77, 61}, lineColor = {70, 70, 70}, lineThickness = 4, extent = {{-23, 39}, {177, -159}}), Rectangle(origin = {91, -32}, fillColor = {52, 52, 52}, fillPattern = FillPattern.Solid, extent = {{-161, 10}, {11, -8}}), Rectangle(origin = {-75, 38}, fillColor = {52, 52, 52}, fillPattern = FillPattern.Solid, extent = {{-27, 6}, {119, -4}}), Rectangle(origin = {-9, 68}, fillColor = {159, 159, 159}, fillPattern = FillPattern.Forward, extent = {{-10, 7}, {20, -65}}), Rectangle(origin = {-19, -4}, fillColor = {106, 106, 106}, fillPattern = FillPattern.Forward, extent = {{-4, 7}, {34, -81}}), Rectangle(origin = {32, 59}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Rectangle(origin = {72, 58}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Ellipse(origin = {32, 56}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-82, 27}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-82, 24}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-42, 26}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {-82, 59}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-82, 56}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-42, 58}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-24, -6}}), Rectangle(origin = {-56, -7}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-56, -10}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-16, -8}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-24, -6}}), Rectangle(origin = {-56, -47}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {-56, -50}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {-16, -48}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {82, -47}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {82, -50}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {122, -48}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {82, -7}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {82, -10}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {122, -8}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Rectangle(origin = {32, 27}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-10, 7}, {12, -15}}), Ellipse(origin = {32, 24}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 6}, {8, -8}}, endAngle = 360), Rectangle(origin = {72, 26}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 0}, {-26, -6}}), Text(origin = {-83, 84}, extent = {{-13, 10}, {13, -10}}, textString = "IN"), Text(origin = {79, -84}, extent = {{-13, 10}, {13, -10}}, textString = "OUT")}, coordinateSystem(initialScale = 0.1)),
          Dialog(group = "Getriebeparameter"),
  Documentation(info = "<html><head></head><body><b>Das Getriebe</b> dient zur Übersetzung der Antriebswelle zur Abtriebswelle. Es muss darauf geachtet werden, dass der Port m_w1 mit der Eingangswelle und m_w mit der Ausgangswelle verbunden ist.&nbsp;<div><br></div><div>Folgende <b>Parameter</b> stehen zur Auswahl:&nbsp;</div><div><br></div><div><b>Übersetzunsverhältnis</b>: Einstellen des Übersetzungsverhältnisses. Die Ausgabedrehzahl wird um diesen Faktor im Vergleich der Eingangsdrehzahl verringert, das Drehmoment (bei einem Wirkungsgrad von 1) erhöht.</div><div><br></div><div><b>Wirkungsgrad</b>: Eingabe des Wirkungsgrades zwischen 0 (0%) und 1 (100%). Das Ausgabedrehmoment wird nach der Übersetzungsberechnung mit diesem Wert multipliziert.&nbsp;</div><div><br></div><div><b>J_Eingangswelle</b> und<b> J_Ausgangswelle</b>: Hier kann die Trägheit der Wellen angegeben werden.</div><div><br></div></body></html>"));
      end Getriebe;

      model Bremse
        //Parameter
        parameter Real b = 10000 annotation(
          Dialog(group = "Bremskonstante"));
        //Variablen
        Real t = 1;
        Real t1;
        Real test;
        Real Bremsmoment;
        //Ports
        Flaschenzug.Ports.M_w m_w1 annotation(
          Placement(visible = true, transformation(origin = {-138, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-121, -9}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
        Flaschenzug.Ports.M_w m_w2 annotation(
          Placement(visible = true, transformation(origin = {112, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {121, -9}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
        Flaschenzug.Ports.BoolIn boolIn1 annotation(
          Placement(visible = true, transformation(origin = {-56, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-67, 57}, extent = {{27, -27}, {-27, 27}}, rotation = 0)));
       
      equation
        t1 = time * t;
        if boolIn1 == true and t1 > 0 then
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
          Icon(graphics = {Rectangle(origin = {0, -8}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, extent = {{-100, 20}, {100, -22}}), Rectangle(origin = {-15, 154}, fillColor = {85, 85, 85}, fillPattern = FillPattern.Vertical, extent = {{-5, -54}, {35, -254}}), Polygon(origin = {32, 70}, fillColor = {200, 0, 0}, fillPattern = FillPattern.Solid, points = {{-10, 30}, {-10, -50}, {8, -50}, {8, 18}, {-10, 30}}), Polygon(origin = {-32, 70}, fillColor = {200, 0, 0}, fillPattern = FillPattern.Solid, points = {{10, 30}, {10, -50}, {-8, -50}, {-8, 18}, {10, 30}})}),
  Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\"><b>Die Bremse&nbsp;</b>dient zum Halten der Position der Masse, wenn das System nicht bestromt wird. Gesteuert wird die Bremse über den Port <b>BoolIn1</b>.</span><div>Dieser erhält ein Signal durch eine Quelle bei der es sich in den Gesamtmodellen um eine Spannungsquelle handelt.&nbsp;</div><div>Gibt die Quelle keine Spannung ab wird der Bremse ein<b> true-Signa</b>l gesendet und das System wird gebremst.<br><div><br></div><div><span style=\"font-size: 12px;\">Es muss darauf geachtet werden, dass der Port <b>m_w1</b> mit der Eingangswelle und <b>m_w2</b> mit der Ausgangswelle verbunden ist.&nbsp;</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Folgende <b>Parameter</b> stehen zur Auswahl:&nbsp;</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Bremskonstante: </b>Mit dieser Konstanten wird die Dämpferkonstante definiert. Das Bremsmoment ergibt sich aus der Multiplikation der Bremskonstanten mit der Ableitung des<b>&nbsp;&nbsp;</b>Ausgangswinkels <b>m_w2</b>.&nbsp;</div></div></div></body></html>"));
      end Bremse;
    annotation(
        Icon(graphics = {Rectangle(origin = {-35, -17}, fillColor = {186, 186, 186}, fillPattern = FillPattern.Horizontal, lineThickness = 1, extent = {{-65, 117}, {135, -61}}), Polygon(origin = {0, -89}, fillPattern = FillPattern.Solid, points = {{-92, -11}, {92, -11}, {64, 11}, {-64, 11}, {-62, 11}, {-92, -11}}), Rectangle(origin = {-17, 53}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-22, 18}, {22, -18}}), Text(origin = {-17, 54}, lineColor = {255, 30, 33}, extent = {{-13, -6}, {13, 6}}, textString = "ABB")}, coordinateSystem(initialScale = 0.1)),
        Documentation(info = "<html><head></head><body><font size=\"4\">Die Antriebskomponenten enthalten Modelle mit einem <b>Moment-Winkel-Port</b>.</font><div><font size=\"4\"><br></font></div><div><font size=\"4\">Es sind<b> enthalten</b>:</font><div><font size=\"4\">Motor</font></div><div><font size=\"4\">Getriebe</font></div><div><font size=\"4\">Bremse</font></div></div></body></html>"));
    end Antriebskomponenten;

    package Gebaeude
      model Decke
        parameter Modelica.SIunits.Height Hoehe = 5 annotation(
          Dialog(group = "Höhe"));
        Flaschenzug.Ports.F_s f_s1 annotation(
          Placement(visible = true, transformation(origin = {6, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {3, -91}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      equation
//f_s.s = konsatant -> Fixpunkt
        f_s1.s = Hoehe;
        annotation(
          Icon(graphics = {Rectangle(origin = {0, -74}, fillPattern = FillPattern.Solid, extent = {{-100, 2}, {100, -2}}), Line(origin = {-29.3731, -69.4329}, points = {{-5, -4}, {5, 4}}), Line(origin = {41.0299, -69.5523}, points = {{-5, -4}, {5, 4}}), Line(origin = {-80.7164, -69.6866}, points = {{-5, -4}, {5, 4}}), Line(origin = {55.4179, -69.2687}, points = {{-5, -4}, {5, 4}}), Line(origin = {-60.0597, -70.0299}, points = {{-5, -4}, {5, 4}}), Line(origin = {-3.38808, -69.7762}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {-49.7462, -69.7463}, points = {{-5, -4}, {5, 4}}), Line(origin = {-80.7164, -69.6866}, points = {{-5, -4}, {5, 4}}), Line(origin = {80.7463, -70.2687}, points = {{-5, -4}, {5, 4}}), Line(origin = {26.6418, -69.5225}, points = {{-5, -4}, {5, 4}}), Line(origin = {-91.9701, -69.9702}, points = {{-5, -4}, {5, 4}}), Line(origin = {11.6269, -69.4926}, points = {{-5, -4}, {5, 4}}), Line(origin = {-17.3283, -69.9254}, points = {{-5, -4}, {5, 4}}), Line(origin = {67.2985, -69.9254}, points = {{-5, -4}, {5, 4}}), Line(origin = {-39.9701, -69.3732}, points = {{-5, -4}, {5, 4}}), Line(origin = {-72.3432, -69.4627}, points = {{-5, -4}, {5, 4}}), Polygon(origin = {0, 12}, fillColor = {211, 60, 14}, fillPattern = FillPattern.CrossDiag, points = {{-100, -84}, {0, 88}, {100, -84}, {34, -84}, {-100, -84}}), Ellipse(origin = {60, 84}, fillColor = {30, 30, 238}, fillPattern = FillPattern.Solid, extent = {{-38, 12}, {38, -12}}, endAngle = 360), Ellipse(origin = {77, 69}, fillColor = {48, 141, 255}, fillPattern = FillPattern.Solid, extent = {{-25, 9}, {25, -9}}, endAngle = 360), Ellipse(origin = {52, 71}, fillColor = {103, 117, 244}, fillPattern = FillPattern.Solid, extent = {{14, 9}, {-14, -9}}, endAngle = 360), Polygon(origin = {-52, 36}, fillColor = {81, 75, 74}, fillPattern = FillPattern.Solid, points = {{-12, -46}, {12, -6}, {12, 46}, {-12, 46}, {-12, 40}, {-12, -46}})}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body>Die Decke bietet einen <b>Fixpunkt</b>. Die Höhe des Fixpunktes kann über den Parameter eingestellt werden. Während der Simulation bleibt dieser Fixpunkt konstant. Ausschließlich die Kraft am F_s - Port kann variieren.<div><br></div><div>Damit kann die Decken-Höhe im Modell simuliert werden.</div></body></html>"));
      end Decke;

      model Boden
        //Parametereingabe
        parameter Modelica.SIunits.Height Hoehe = 5 annotation(
          Dialog(group = "Höhe"));
        Flaschenzug.Ports.F_s f_s1 annotation(
          Placement(visible = true, transformation(origin = {6, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-2, 10}, extent = {{-70, -70}, {70, 70}}, rotation = 0)));
      equation
//f_s.s = konsatant  -> Fixpunkt
        f_s1.s = Hoehe;
        annotation(
          Icon(graphics = {Rectangle(origin = {-2, -74}, fillPattern = FillPattern.Solid, extent = {{-98, 14}, {102, -26}})}, coordinateSystem(initialScale = 0.1)),
          Documentation(info = "<html><head></head><body>Der Boden bietet einen <b>Fixpunkt</b>. Die Höhe des Fixpunktes kann über den Parameter eingestellt werden. Während der Simulation bleibt dieser Fixpunkt konstant. Ausschließlich die Kraft am F_s - Port kann variieren.</body></html>"));
      end Boden;
     annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-1, 80}, fillColor = {208, 41, 18}, fillPattern = FillPattern.CrossDiag, lineThickness = 2.75, points = {{1, 20}, {-99, -20}, {99, -20}, {1, 20}}), Rectangle(origin = {-1, -20}, lineThickness = 2.75, extent = {{-99, 80}, {99, -80}}), Rectangle(origin = {-1, -80}, fillPattern = FillPattern.Solid, extent = {{-99, 20}, {99, -20}})}),
        Documentation(info = "<html><head></head><body>Hierin sind Modelle, die in der Simulation als Fixpunkt dienen hinterlegt.</body></html>"));
    end Gebaeude;

    package Sonderkomponenten

      model Lastmoment
  Flaschenzug.Ports.M_w m_w1 annotation(
          Placement(visible = true, transformation(origin = {-58, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-112, -4.44089e-16}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
        //Einstellen des Lastmoments
        parameter Modelica.SIunits.Torque Ml(unit "Nm") = 4 annotation(
          Dialog(group = "Lastmoment"));
      equation
//konstantes Moment an Port weitergeben
        -Ml = m_w1.M;
        annotation(
          Icon(graphics = {Ellipse(origin = {-69, 45}, lineThickness = 0.75, extent = {{-31, 55}, {169, -145}}, endAngle = 360), Text(origin = {-48, 53}, fillPattern = FillPattern.Solid, extent = {{-12, 9}, {110, -113}}, textString = "Lastmoment"), Line(origin = {70.9516, 78.3781}, points = {{0.723622, -9.98965}, {-17.2764, -5.9896}, {0.723622, -9.98965}, {-1.2764, 8.0104}, {0.7236, -9.9896}}, thickness = 0.75)}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body>Das Lastmoment ermöglicht ein Testaufbau ohne Seilwinde und Gewicht. Es erzeugt ein konstantes Lastmoment an seinem m_w- Port. Das Lastmoment kann als Parameter eingegeben werden.</body></html>"));
  end Lastmoment;

      model Boolesche_Senke
        Flaschenzug.Ports.BoolIn boolIn1 annotation(
          Placement(visible = true, transformation(origin = {-114, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-124, -8.88178e-16}, extent = {{24, -24}, {-24, 24}}, rotation = 0)));
      equation

        annotation(
          Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {-108, 54}, lineThickness = 0.5, extent = {{38, 16}, {178, -48}})}),
          Documentation(info = "<html><head></head><body>Die <b>Boolsche_Senke</b> ist eine Senke für boolschen Werte. Sollte im Gesamtmodell ein offener Boolscher Output offen sein, kann die Senke dazu benutzt werden, diesen Wert aufzunehmen. Im Simulationsmodell hat die Senke einen optischen Charakter. Technisch wird sie (anders wie die boolesche Quelle) nicht benötigt.</body></html>"));
      end Boolesche_Senke;

      model Boolesche_Quelle
  Flaschenzug.Ports.BoolOut boolOut1 annotation(
          Placement(visible = true, transformation(origin = {130, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 3.55271e-15}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
        //Startparameter
        parameter Boolean Eingabe = false annotation(
          Dialog(group = "Ausgabe"));
        //Aenderung nach einem bestimmten Zeitpunkt
        parameter Boolean Aenderung = false annotation(
          Dialog(group = "Zeitgesteuert ändern auf"));
        parameter Real nach(unit "s") = 1 annotation(
          Dialog(group = "Zeitgesteuert ändern auf"));
      equation
        if time <= nach then
          boolOut1 = Aenderung;
        else
          boolOut1 = Eingabe;
        end if;
        annotation(
          Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-100, 100}, {100, -100}}), Line(origin = {15.48, 9.93}, points = {{-73.1063, -71.1063}, {-15.1063, -71.1063}, {-15.1063, 62.8937}, {40.8937, 62.8937}}, thickness = 1)}),
          Documentation(info = "<html><head></head><body>Die Boolsche Quelle ermögtlicht bie Modellierungen ein boolsches Signal konstant zu halten, oder zeitgesteuert zu ändern. Das erzeugte Signal wird aus dem boolschen Output-Port ausgegeben.<div><br></div><div><b>Folgende Parameter </b>stehen zur Verfügung:</div><div><br></div><div><b>\"Eingabe\":</b> Dieser Wert nimmt der boolsche Ausgangsport von Beginn an der Simulation an</div><div><b>\"nach\":</b> soll eine Änderung des boolschen Wertes bei einem bestimmten Zeitpunkt erfolgen, so kann unter der Angabe \"nach\" der Zeitpunkt eingegeben werden.</div><div><b>\"Aenderung\":</b> Diesen Wert nimmt der boolsche Ausgangsport ab dem Zeitpunkt \"nach\" an.</div><div><br></div><div><b>Hinweis:</b></div><div>Soll keine Änderung des boolschen Wertes simuliert werden, kann entweder der Parameter \"nach\" auf einen Zeitpunktnach dem Simulationsende, oder \"Anderung\"=\"Eingabe\" &nbsp;gesetzt werden.</div></body></html>"));
      end Boolesche_Quelle;
  annotation(
        Icon(graphics = {Polygon(origin = {-40, 0}, fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, points = {{-60, 0}, {60, 100}, {60, -100}, {-60, 0}}), Polygon(origin = {40, 0}, fillColor = {0, 255, 255}, fillPattern = FillPattern.Solid, points = {{-60, -2}, {60, 100}, {60, -100}, {-60, -2}})}),
        Documentation(info = "<html><head></head><body>Die Sonderkomponenten-Bibliothek beinhaltet Modelle, die zum Einsatz kommen, um einzelne Modelle und deren Interaktion in einem kleinen, mit wenigen Einzelnen Komponenten audgestatteten Modell zu <b>testen</b>.&nbsp;<div><br><div>Unter <b>Beispiele/Sonderbeispiele</b> sind zwei Modelle mit Sonderkomponenten ausgerüstet.</div></div></body></html>"));
    end Sonderkomponenten;
    annotation(
      Icon(graphics = {Rectangle(origin = {-50, 50}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Rectangle(origin = {48, 50}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Rectangle(origin = {-48, -50}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Rectangle(origin = {50, -50}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Rectangle(origin = {9, -8}, lineThickness = 2, extent = {{-109, 108}, {91, -92}})}));
  end Modelle;
  
  package Beispiele
  
    model Flaschenzug_Boden
  Flaschenzug.Modelle.Gebaeude.Decke decke1 annotation(
        Placement(visible = true, transformation(origin = {74, 76}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Flaschenzug.Modelle.Antriebskomponenten.Getriebe getriebe1(Uebersetzung = 2)  annotation(
        Placement(visible = true, transformation(origin = {-2, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Antriebskomponenten.Motor motor1 annotation(
        Placement(visible = true, transformation(origin = {-76, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Antriebskomponenten.Bremse bremse1 annotation(
        Placement(visible = true, transformation(origin = {-40, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Massen.Masse masse1(m = 40)  annotation(
        Placement(visible = true, transformation(origin = {76, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Flaschenzuege.Flaschenzug_Modell flaschenzug_Modell1(Zugwinkel(displayUnit = "rad"))  annotation(
        Placement(visible = true, transformation(origin = {75, 17}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Flaschenzug.Modelle.Seilwinden.Seilwinde seilwinde1 annotation(
        Placement(visible = true, transformation(origin = {34, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Spannungsquellen.Gesteuert gesteuert1(U = 48)  annotation(
        Placement(visible = true, transformation(origin = {-73, -11}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
    equation
      connect(bremse1.boolIn1, gesteuert1.boolOut1) annotation(
        Line(points = {{-46, -42}, {-56, -42}, {-56, -34}, {-36, -34}, {-36, 8}, {-96, 8}, {-96, -2}, {-90, -2}}));
      connect(flaschenzug_Modell1.boolOut1, gesteuert1.boolIn1) annotation(
        Line(points = {{72, 36}, {-100, 36}, {-100, -12}, {-90, -12}, {-90, -10}}));
      connect(motor1.u_i, gesteuert1.u_i) annotation(
        Line(points = {{-84, -48}, {-96, -48}, {-96, -32}, {-44, -32}, {-44, -10}, {-56, -10}, {-56, -12}}));
      connect(getriebe1.m_w, seilwinde1.m_w) annotation(
        Line(points = {{10, -52}, {22, -52}, {22, -50}, {22, -50}}));
      connect(flaschenzug_Modell1.f_s2, seilwinde1.f_s) annotation(
        Line(points = {{48, 10}, {40, 10}, {40, -38}, {40, -38}}));
      connect(flaschenzug_Modell1.f_s1, decke1.f_s1) annotation(
        Line(points = {{76, 42}, {74, 42}, {74, 54}, {74, 54}}));
      connect(flaschenzug_Modell1.f_s, masse1.f_s) annotation(
        Line(points = {{76, -10}, {76, -10}, {76, -26}, {76, -26}}));
      connect(bremse1.m_w2, getriebe1.m_w1) annotation(
        Line(points = {{-28, -48}, {-20, -48}, {-20, -46}, {-14, -46}, {-14, -46}}));
      connect(motor1.m_w, bremse1.m_w1) annotation(
        Line(points = {{-66, -48}, {-52, -48}, {-52, -48}, {-52, -48}}));
      annotation(
        Diagram(graphics = {Rectangle(origin = {0, -56}, fillPattern = FillPattern.Solid, extent = {{-100, -44}, {100, -4}})}, coordinateSystem(initialScale = 0.1)),
        Icon(graphics = {Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}}), Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body>Der Gesamtaufbau <b>Flaschenzug_Boden</b><i> </i>stellt eine Hubarbeit dar, bei welcher die Antriebskomponenten auf dem Boden stehen. Die Masse wird über einen Flaschenzug angehoben. Ist der Flaschenzug komplett zusammengefahren, so gibt er am boolschen Ausgang (blau) ein true aus, welches die Spannungsquelle abschaltet. Das Signal wird durch die Spannungsquelle hindurch, an die Bremse weitergegeben. Diese bekommt das Signal und schließt, sodass die Masse bei Spannungsfreiheit nicht nach unten absacken kann. &nbsp;<div><br></div><div>Die einzelnen Modelle sind alle parametrierbar <b>(Infos: siehe Modell-Readme in der Bibliothek)</b>.<br><div><br></div><div>Empfehlung Simulationszeit für eingestellte Parameter: <b>20&nbsp;s</b></div></div><div><br></div><div>Bei der Auswertung der Simulation muss bei dem zurückgelegten Weg des Flaschenzugports f_s und f_s2 der Offset beachtet werden. Dieser beträgt den Wert des Startwertes (Position der Masse zum Zeitpunkt 0).&nbsp;</div><div>Beispiel: Startwert 2 m = Offset 2 m, f_s.s = 5 -2 = 3m f_s2.s = -9 m damit stimmt die Rollenanzahl n = 3.</div></body></html>"));
  
    end Flaschenzug_Boden;
  
    model Flaschenzug_Decke
      Flaschenzug.Modelle.Gebaeude.Decke decke1 annotation(
        Placement(visible = true, transformation(origin = {74, 74}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
      Flaschenzug.Modelle.Flaschenzuege.Flaschenzug_Modell_b flaschenzug_Modell_b1(Zugwinkel(displayUnit = "rad"), n = 2)  annotation(
        Placement(visible = true, transformation(origin = {75, 9}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
      Flaschenzug.Modelle.Antriebskomponenten.Getriebe getriebe1 annotation(
        Placement(visible = true, transformation(origin = {8, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Flaschenzug.Modelle.Antriebskomponenten.Motor motor1 annotation(
        Placement(visible = true, transformation(origin = {-72, 42}, extent = {{12, -12}, {-12, 12}}, rotation = 180)));
      Modelle.Antriebskomponenten.Bremse bremse1 annotation(
        Placement(visible = true, transformation(origin = {-24, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelle.Massen.Bierkasten bierkasten1 annotation(
        Placement(visible = true, transformation(origin = {76, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Seilwinden.Seilwinde_Decke seilwinde_Decke1 annotation(
        Placement(visible = true, transformation(origin = {40, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Spannungsquellen.Gesteuert gesteuert1 annotation(
        Placement(visible = true, transformation(origin = {-66, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
  connect(gesteuert1.u_i, motor1.u_i) annotation(
        Line(points = {{-54, -4}, {-42, -4}, {-42, 14}, {-88, 14}, {-88, 41}, {-81, 41}}));
  connect(motor1.m_w, bremse1.m_w1) annotation(
        Line(points = {{-57, 40}, {-50, 40}, {-50, 44}, {-36, 44}}));
  connect(gesteuert1.boolIn1, flaschenzug_Modell_b1.boolOut1) annotation(
        Line(points = {{-78, -4}, {-100, -4}, {-100, -54}, {82, -54}, {82, -54}, {96, -54}, {96, 30}, {78, 30}, {78, 28}}));
  connect(seilwinde_Decke1.f_s, flaschenzug_Modell_b1.f_s2) annotation(
        Line(points = {{46, 32}, {48, 32}, {48, 22}, {48, 22}}));
  connect(flaschenzug_Modell_b1.f_s1, decke1.f_s1) annotation(
        Line(points = {{76, 34}, {76, 34}, {76, 52}, {74, 52}}));
  connect(bierkasten1.f_s, flaschenzug_Modell_b1.f_s) annotation(
        Line(points = {{76, -30}, {74, -30}, {74, -18}, {76, -18}}));
      connect(bremse1.boolIn1, gesteuert1.boolOut1) annotation(
        Line(points = {{-30, 50}, {-44, 50}, {-44, 20}, {-36, 20}, {-36, -16}, {-94, -16}, {-94, 2}, {-78, 2}, {-78, 2}}));
  connect(getriebe1.m_w, seilwinde_Decke1.m_w) annotation(
        Line(points = {{20, 41}, {24, 41}, {24, 44}, {28, 44}}));
  connect(bremse1.m_w2, getriebe1.m_w1) annotation(
        Line(points = {{-12, 44}, {-4, 44}, {-4, 48}}));
      annotation(
        Diagram(graphics = {Rectangle(origin = {0, -2}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {0, -56}, fillPattern = FillPattern.Solid, extent = {{-100, -44}, {100, -4}}), Rectangle(origin = {-26, 55}, fillPattern = FillPattern.Solid, extent = {{76, -1}, {-74, 1}})}, coordinateSystem(initialScale = 0.1)),
        Icon(graphics = {Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}}), Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body>Der Gesamtaufbau&nbsp;<b>Flaschenzug_Decke</b><i>&nbsp;</i>stellt eine Hubarbeit dar, bei welcher die Antriebskomponenten an der Decke angebracht sind. Die Masse wird über einen Flaschenzug angehoben. Ist der Flaschenzug komplett zusammengefahren, so gibt er am boolschen Ausgang (balu) ein true aus, welches die Spannungsquelle abschält. Das Signal wird durch die Spannungsquelle hindurch, an die Bremse weitergegeben. Diese bekommt das Signal und schließt, sodass die Masse bei Spannungsfreiheit nicht nach unten absacken kann. &nbsp;<div>Im Gegensaztz zum Modell Flasschenzug_Boden kann hier bei diesem Modell bei selber Parametrierung nicht die selbe Last bei gleichbleibender Leistungsaufnahme des Motors angehoben werden. Das resutiert aus der nach oben gerichteten Zugrichtung (siehe Flaschenzu_Modell_b). &nbsp;</div><div><br></div><div><span style=\"font-size: 12px;\">Die einzelnen Modelle sind alle parametrierbar&nbsp;</span><b style=\"font-size: 12px;\">(Infos: siehe Modell-Readme in der Bibliothek)</b><span style=\"font-size: 12px;\">.</span></div><div><br></div><div>Empfehlung Simulationszeit für eingestellte Parameter:&nbsp;<b>20&nbsp;s</b></div><div><b><br></b></div><div><div style=\"font-size: 12px;\">Bei der Auswertung der Simulation muss bei dem zurückgelegten Weg des Flaschenzugports f_s und f_s2 der Offset beachtet werden. Dieser beträgt den Wert des Startwertes (Position der MAsse zum Zeitpunkt 0).&nbsp;</div><div style=\"font-size: 12px;\">Beispiel: Startwert 2 m = Offset 2 m, f_s.s = 5 -2 = 3m f_s2.s = -9 m damit stimmt die Rollenanzahl n = 3.</div></div></body></html>"));
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
        Placement(visible = true, transformation(origin = {74, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Flaschenzug.Modelle.Flaschenzuege.Flaschenzug_Modell flaschenzug_Modell1(Zugwinkel(displayUnit = "rad"))  annotation(
        Placement(visible = true, transformation(origin = {73, 17}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Flaschenzug.Modelle.Seilwinden.Seilwinde seilwinde1 annotation(
        Placement(visible = true, transformation(origin = {38, -48}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Flaschenzug.Modelle.Spannungsquellen.Zeitgesteuert zeitgesteuert1(U_A = 36, t1 = 6, t2 = 10, t3 = 11)  annotation(
        Placement(visible = true, transformation(origin = {-76, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Sonderkomponenten.Boolesche_Senke boolesche_Senke1 annotation(
        Placement(visible = true, transformation(origin = {24, 36}, extent = {{12, -12}, {-12, 12}}, rotation = 0)));
    equation
      connect(boolesche_Senke1.boolIn1, flaschenzug_Modell1.boolOut1) annotation(
        Line(points = {{39, 36}, {70, 36}}));
      connect(flaschenzug_Modell1.f_s, masse1.f_s) annotation(
        Line(points = {{73, -9}, {73, -22}, {74, -22}}));
      connect(flaschenzug_Modell1.f_s1, decke1.f_s1) annotation(
        Line(points = {{73, 43}, {74, 43}, {74, 54}}));
      connect(flaschenzug_Modell1.f_s2, seilwinde1.f_s) annotation(
        Line(points = {{47, 10}, {44, 10}, {44, -34}, {46, -34}}));
  connect(zeitgesteuert1.boolOut1, bremse1.boolIn1) annotation(
        Line(points = {{-89, 0}, {-98, 0}, {-98, -26}, {-60, -26}, {-60, -42}, {-46, -42}}));
  connect(motor1.u_i, zeitgesteuert1.u_i) annotation(
        Line(points = {{-84, -48}, {-100, -48}, {-100, -22}, {-52, -22}, {-52, -6}, {-64, -6}}));
      connect(getriebe1.m_w, seilwinde1.m_w) annotation(
        Line(points = {{10, -52}, {22, -52}, {22, -48}, {24, -48}}));
      connect(bremse1.m_w2, getriebe1.m_w1) annotation(
        Line(points = {{-28, -48}, {-20, -48}, {-20, -46}, {-14, -46}, {-14, -46}}));
      connect(motor1.m_w, bremse1.m_w1) annotation(
        Line(points = {{-66, -48}, {-52, -48}, {-52, -48}, {-52, -48}}));
      annotation(
        Diagram(graphics = {Rectangle(origin = {0, -56}, fillPattern = FillPattern.Solid, extent = {{-100, -44}, {100, -4}})}, coordinateSystem(initialScale = 0.1)),
        Icon(graphics = {Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}}), Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body>Das Gesamtmodell <i>Flaschenzug_Boden_Heben_Senken </i>ist wie die Benennung andeutet vom Modell Flaschenzug_Boden abgeleitet. Der Unterschied besteht in der Spannungsquelle. &nbsp;Diese ist Zeitgesteuert, und so parametriert, dass die Masse bis 6s hochgezogen, dann bis 10s gehalten, und anschleißend bis Sekunde 11 heruntergelassen wird. Dananch wird die Masse wieder auf der Position gehalten.<div><br></div><div><span style=\"font-size: 12px;\">Die einzelnen Modelle sind alle parametrierbar&nbsp;</span><b style=\"font-size: 12px;\">(Infos: siehe Modell-Readme in der Bibliothek)</b><span style=\"font-size: 12px;\">.</span><div><br></div><div>Empfehlung Simulationszeit für eingestellte Parameter:&nbsp;<b>20&nbsp;s</b></div></div></body></html>"));
    end Flaschenzug_Boden_Heben_Senken;

    package Sonderbeispiele
      model Motor_Getriebe_Seilwinde
        Flaschenzug.Modelle.Antriebskomponenten.Motor motor1 annotation(
          Placement(visible = true, transformation(origin = {-59, 39}, extent = {{-21, 21}, {21, -21}}, rotation = 0)));
        Flaschenzug.Modelle.Antriebskomponenten.Getriebe getriebe1(Uebersetzung = 6)  annotation(
          Placement(visible = true, transformation(origin = {3, 39}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
        Flaschenzug.Modelle.Massen.Bierkasten bierkasten1 annotation(
          Placement(visible = true, transformation(origin = {81, -51}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Flaschenzug.Modelle.Spannungsquellen.Konstantspannung konstantspannung1(KonstanteSpannung = true, U = -48)  annotation(
          Placement(visible = true, transformation(origin = {-131, 37}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  Flaschenzug.Modelle.Seilwinden.Seilwinde_Decke seilwinde_Decke annotation(
          Placement(visible = true, transformation(origin = {69, 39}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
      equation
        connect(konstantspannung1.u_i, motor1.u_i) annotation(
          Line(points = {{-105, 37}, {-100, 37}, {-100, 36}, {-74, 36}}));
        connect(motor1.m_w, getriebe1.m_w1) annotation(
          Line(points = {{-32, 36}, {-20, 36}, {-20, 46}, {-20, 46}}));
  connect(getriebe1.m_w, seilwinde_Decke.m_w) annotation(
          Line(points = {{26, 34}, {44, 34}, {44, 40}, {44, 40}}));
  connect(seilwinde_Decke.f_s, bierkasten1.f_s) annotation(
          Line(points = {{80, 14}, {80, 14}, {80, -32}, {82, -32}, {82, -32}}));
        annotation(
          Diagram(graphics = {Rectangle(origin = {0, 104}, fillPattern = FillPattern.Solid, extent = {{-100, -44}, {100, -4}})}, coordinateSystem(initialScale = 0.1)),
          Icon(graphics = {Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}}), Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body>Dieser Aufbau zeigt ein Hebevorgang ohne Flaschenzug, um den direkten Vergleich zu haben, zwichen der Verwendeung (s. Modell Flaschenzug_Decke) und Verzicht eines Flaschenzugs. Die hier bewegbare Masse ist kleiner als bei der Verwendung eines Flaschenzugs.<div><br></div><div><span style=\"font-size: 12px;\">Die einzelnen Modelle sind alle parametrierbar&nbsp;</span><b style=\"font-size: 12px;\">(Infos: siehe Modell-Readme in der Bibliothek)</b><span style=\"font-size: 12px;\">.</span></div></body></html>"));
      end Motor_Getriebe_Seilwinde;

      model Test_Sonderkomponenten
        Flaschenzug.Modelle.Antriebskomponenten.Motor motor1 annotation(
          Placement(visible = true, transformation(origin = {20, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
        Flaschenzug.Modelle.Sonderkomponenten.Lastmoment lastmoment1(Ml = 4) annotation(
          Placement(visible = true, transformation(origin = {80, -28}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Flaschenzug.Modelle.Spannungsquellen.Gesteuert gesteuert1 annotation(
          Placement(visible = true, transformation(origin = { -32, -28}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Flaschenzug.Modelle.Sonderkomponenten.Boolesche_Senke boolesche_Senke1 annotation(
          Placement(visible = true, transformation(origin = {-32, 24}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Flaschenzug.Modelle.Sonderkomponenten.Boolesche_Quelle boolesche_Quelle1(Eingabe = true, nach = 5)  annotation(
          Placement(visible = true, transformation(origin = {-94, -28}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
      equation
        connect(boolesche_Quelle1.boolOut1, gesteuert1.boolIn1) annotation(
          Line(points = {{-74, -28}, {-54, -28}, {-54, -28}, {-52, -28}}));
        connect(gesteuert1.boolOut1, boolesche_Senke1.boolIn1) annotation(
          Line(points = {{-52, -18}, {-68, -18}, {-68, 24}, {-52, 24}}));
        connect(gesteuert1.u_i, motor1.u_i) annotation(
          Line(points = {{-12, -28}, {6, -28}, {6, -28}, {6, -28}}));
        connect(motor1.m_w, lastmoment1.m_w1) annotation(
          Line(points = {{44, -26}, {52, -26}, {52, -28}, {56, -28}}));
        annotation(
          Diagram(coordinateSystem(initialScale = 0.1)),
          Icon(graphics = {Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}}), Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">Der <b>Motorprüfstand</b>&nbsp;dient zum demonstrieren aller Sonderkomponenten: Lastmoment, boolesche Quelle und Senke.&nbsp;</span><div>Die boolesche Quelle ist so eingestellt, dass sie nach 5 Sekunden von <i>true</i> auf <i>false</i> springt. Dadurch schaltet die Spannungsquelle ab. Das Lastmoment gibt über die gesamte Zeit ein Moment auf die Welle. Zu Beginn beschleunigt der Motor desshalb langsamer als ohne Last, nach 5 Sekunden geht der Motor in dem generatorischen Betrieb über.</div><div>Das Beislpiel zeigt die boolesche Senke, die technisch nicht benötigt wird, jedoch den sonst offenen booleschen Ausgang der Spannungsquelle optisch schön aufnimmt.&nbsp;</div><div><br></div><div><span style=\"font-size: 12px;\">Die einzelnen Modelle sind alle parametrierbar&nbsp;</span><b style=\"font-size: 12px;\">(Infos: siehe Modell-Readme in der Bibliothek)</b><span style=\"font-size: 12px;\">.</span></div></body></html>"));
      end Test_Sonderkomponenten;

      model Test_Flaschenzug
        Flaschenzug.Modelle.Gebaeude.Decke decke annotation(
          Placement(visible = true, transformation(origin = {-38, 74}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Flaschenzug.Modelle.Flaschenzuege.Flaschenzug_Modell flaschenzug_Modell(Flaschengewicht_oben = 0,Flaschengewicht_unten = 0, Zugwinkel(displayUnit = "rad"), s = 5)  annotation(
          Placement(visible = true, transformation(origin = {-38, 14}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Flaschenzug.Modelle.Massen.Bierkasten bierkasten(m = 300)  annotation(
          Placement(visible = true, transformation(origin = {-36, -40}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Flaschenzug.Modelle.Massen.Masse masse(m = 100)  annotation(
          Placement(visible = true, transformation(origin = {-88, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flaschenzug.Modelle.Flaschenzuege.Flaschenzug_Modell_b flaschenzug_Modell_b(Flaschengewicht_oben = 0, Flaschengewicht_unten = 0)  annotation(
          Placement(visible = true, transformation(origin = {57, 9}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Flaschenzug.Modelle.Gebaeude.Decke decke1 annotation(
          Placement(visible = true, transformation(origin = {57, 75}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Flaschenzug.Modelle.Massen.Bierkasten bierkasten1(m = 300)  annotation(
          Placement(visible = true, transformation(origin = {58, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelle.Massen.Masse masse1(m = 100)  annotation(
          Placement(visible = true, transformation(origin = {8, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      equation
  connect(flaschenzug_Modell.f_s1, decke.f_s1) annotation(
          Line(points = {{-38, 41}, {-38, 35.5}, {-37, 35.5}, {-37, 50}}));
  connect(flaschenzug_Modell.f_s, bierkasten.f_s) annotation(
          Line(points = {{-38, -14}, {-38, -19.5}, {-36, -19.5}, {-36, -28}}));
  connect(masse.f_s, flaschenzug_Modell.f_s2) annotation(
          Line(points = {{-88, -10}, {-66, -10}, {-66, 7}, {-65, 7}}));
  connect(decke1.f_s1, flaschenzug_Modell_b.f_s1) annotation(
          Line(points = {{58, 52}, {57.5, 52}, {57.5, 44}, {57, 44}}));
  connect(masse1.f_s, flaschenzug_Modell_b.f_s2) annotation(
          Line(points = {{8, 4}, {18, 4}, {18, 26}, {22, 26}}));
  connect(bierkasten1.f_s, flaschenzug_Modell_b.f_s) annotation(
          Line(points = {{58, -32}, {58, -27}, {57, -27}}));
      annotation(
          Diagram(graphics = {Rectangle(origin = {-2, -56}, fillPattern = FillPattern.Solid, extent = {{-100, -44}, {100, -4}})}, coordinateSystem(initialScale = 0.1)),
          Icon(graphics = {Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}}), Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body>Dieses Modell ist zum Testen des Flaschenzugs entworfen worden. Die 40kg schwere Masse zieht den 100kg schweren Bierkasten in der Simulation nach oben. Der Flaschenzug hat ene Übersetzung von 3.&nbsp;<div>Eine boolesche Senke ist nicht notwendig.</div><div><br></div><div><span style=\"font-size: 12px;\">Die einzelnen Modelle sind alle parametrierbar&nbsp;</span><b style=\"font-size: 12px;\">(Infos: siehe Modell-Readme in der Bibliothek)</b><span style=\"font-size: 12px;\">.</span></div></body></html>"));
      end Test_Flaschenzug;
      annotation(
        Diagram(graphics = {Rectangle(origin = {0, -56}, fillPattern = FillPattern.Solid, extent = {{-100, -44}, {100, -4}})}, coordinateSystem(initialScale = 0.1)),
        Icon(graphics = {Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}}), Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body>Die <b>Sonderbeispiele</b> enthalten Modelle mit Sonderkomponenten und Testaufbauten um einzelne Komponenten der Bibliothek in kleineren Modellen zu testen. Sie enthalten verkleinerte Modelle mit einer geringeren Anzahl an Komponenten als im Gesamtaufbau (s. Beispiele).</body></html>"));
    end Sonderbeispiele;
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {-70, 41}, lineColor = {53, 202, 46}, fillColor = {55, 173, 65}, fillPattern = FillPattern.Solid, extent = {{-30, 9}, {70, -89}}), Polygon(origin = {30, 80}, lineColor = {63, 188, 44}, fillColor = {88, 195, 64}, fillPattern = FillPattern.Solid, points = {{70, -82}, {-30, 20}, {-30, -20}, {-30, -178}, {70, -82}})}));
  end Beispiele;
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-1, 80}, fillColor = {208, 41, 18}, fillPattern = FillPattern.CrossDiag, lineThickness = 2.75, points = {{1, 20}, {-99, -20}, {99, -20}, {1, 20}}), Rectangle(origin = {-1, -20}, lineThickness = 2.75, extent = {{-99, 80}, {99, -80}}), Rectangle(origin = {-1, -80}, fillPattern = FillPattern.Solid, extent = {{-99, 20}, {99, -20}}), Rectangle(origin = {-67, -41}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Rectangle(origin = {-17, -41}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Rectangle(origin = {17, 41}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Rectangle(origin = {61, -41}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Line(origin = {-82.4624, -38.3131}, points = {{-15.0582, -1.05816}, {-1.05816, -1.05816}, {14.9418, 0.941844}}, thickness = 4), Line(origin = {-82.4624, -38.3131}, points = {{-15.0582, -1.05816}, {-1.05816, -1.05816}, {14.9418, 0.941844}}, thickness = 4), Line(origin = {-31.9997, -38.3131}, points = {{-15.0582, -1.05816}, {-1.05816, -1.05816}, {14.9418, 0.941844}}, thickness = 4), Line(origin = {-0.656432, 27.5078}, points = {{-11.0582, -55.0582}, {-1.05816, -1.05816}, {14.9418, 0.941844}}, thickness = 4), Line(origin = {48.2391, -26.7161}, points = {{-17.0582, 58.9418}, {-1.05816, -1.05816}, {14.9418, 0.941844}}, thickness = 4)}));
end Flaschenzug;
