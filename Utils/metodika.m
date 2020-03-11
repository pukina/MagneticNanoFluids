%% Deltu aprekinasana
% 1) Tiek noteikti eksperimenta sakuma laiks, râmîða izmçri, un pikseïi
% intensitâtes vçrtîbas abiem ðíîdumiem manuâli.

% 2) Izmantojot ðîs vçrtîbas, katras koncentracijas katra eksperimenta
% katram kadram tiek aprçíinâta koncentrâcija visos Y-ass lîmeòos. 

% 3) Izmantojot aprçíinâto koncentrâcijas lîkni katram kadram var
% aproksimçt ar erf funkciju. Erf funckiju adaptçjam priekð reìiona [0,1],
% kas tiek definçta ðâdi: 
%                              (erf(x)+1)/2
% +-Deltas tiek uzskatîtas, kur x = +1 vai x = -1, jeb (erf(x)+1)/2)=0.9214
% un (erf(-1)+1)/2) = 0.0786
% Atrodot pikseïu vai mm vçrtîbas pie kuras koncentrâcija ir vistuvâk ðîm
% te abâm vçrtîbâm ir iespçjams noteikt deltas. Piemçram ja 100ajâ pikseïu
% rindâ vidçjâ koncentrâcija 0.9214, tad tâ bûtu +delta, bet 300ajâ rindâ
% pie 0.0786 varçtu bût -delta. Tad deltas izmçrs ir 300-100= 200pikseïi.
% Realitâtç ir jâpâriet uz mm no pikseïiem, ko dara izmantojot kalibrâcijas
% datus.

% Izmantojot vairâkus punktus, lai atrastu deltas nepiecieðams pielâgot erf
% funckiju. Ja iegûst delta min un delta max var aprçíinât deltas vidçjo
% punktu (Xcenter) un deltas kopçjo platumu (Delta). Izmantojot ðos
% lielumus var uzzîmçt erf lîkni tajâs paðâs koordinâtçs kur koncentrâcija.
% Izmantojot koncentrâcijas lîknes intervâlu salîdzinâjumu
Xcenter = (dmax + dmin)/2
Delta = (dmax - dmin)/2
  (erf( (X -Xcenter)/ Delta )        +1)      /2);

%4) Tâ kâ pielîdzinât erf funckiju tikai pçc 2 punktiem rada nestabilitâti
% datos, tad tiek izmantoti punkti intervâlos 0.0786(+-)0.02 un 0.9214(+-)0.02
% Tâ kâ dati daþreiz nav vienmçr intervâlâ no 0-1, tad ðîs vçrtîbas tiek
% scalotas atkarîbâ no esoðajâ kadrâ min un max koncentrâcijas.

%5) Nevienmçrîga apgaismojuma dçï var rasties koncentrâcijas lîknes, kuras
%galos reversç virzienu, kam nevajadzçtu notikt. Izskaidrojums ir
%apgaismojums, kuram samazinoties stûros attçls kïûst tumðâks. Vietâs, kur
%bija vçrojama ðâda veida reversâcija tika òemta vçrâ pirmâ kadra maksimâlâ
%vai minimâlâ vçrtîba ðajos punktos un vçlâkos kadros attiecîgi mçrogota.
% Piemçram, ja 0-85 pikselis parâda lejupejoðo koncentrâciju kâ gadîts,
% un 85-100 uzrâda augðupejoðu, tad visiem kadriem 85-100 pikselis tiek
% mçrogots pçc pirmâ kadra, bet pârejiem nemainîgi.

%6) Visiem eksperimentiem tiek mçrogota koncentrâcija, lai pirmajâ kadrâ
%bûtu intervalâ no 0-1, bet pârçjiem tiek pielâgots pçc pirmâ kadra skalas.

%7) Daþiem eksperimentiem bija vçrojams kritums delta vs Time grafikâ
%noteiktos intervâlos. Delta virziens ðiem intervâliem bija ïoti
%lîdzîgs kâ pârçjam grafikam, bet ar amplitûdas nobîdi. Tika uzskatîs, ka
%tas ir apgaismojuma maiòas dçï un nepiecieðams koriìçt datos, lai
%amplitûdu salâgotu ar pârejo grafiku. Tas tika darîts manuâli atliekot 2
%punktus intervâla sâkumam un beigâm, un aizstâjot esoðos datus ar taisni +
%nelielu gausa troksni.
%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  