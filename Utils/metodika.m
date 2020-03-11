%% Deltu aprekinasana
% 1) Tiek noteikti eksperimenta sakuma laiks, r�m��a izm�ri, un pikse�i
% intensit�tes v�rt�bas abiem ���dumiem manu�li.

% 2) Izmantojot ��s v�rt�bas, katras koncentracijas katra eksperimenta
% katram kadram tiek apr��in�ta koncentr�cija visos Y-ass l�me�os. 

% 3) Izmantojot apr��in�to koncentr�cijas l�kni katram kadram var
% aproksim�t ar erf funkciju. Erf funckiju adapt�jam priek� re�iona [0,1],
% kas tiek defin�ta ��di: 
%                              (erf(x)+1)/2
% +-Deltas tiek uzskat�tas, kur x = +1 vai x = -1, jeb (erf(x)+1)/2)=0.9214
% un (erf(-1)+1)/2) = 0.0786
% Atrodot pikse�u vai mm v�rt�bas pie kuras koncentr�cija ir vistuv�k ��m
% te ab�m v�rt�b�m ir iesp�jams noteikt deltas. Piem�ram ja 100aj� pikse�u
% rind� vid�j� koncentr�cija 0.9214, tad t� b�tu +delta, bet 300aj� rind�
% pie 0.0786 var�tu b�t -delta. Tad deltas izm�rs ir 300-100= 200pikse�i.
% Realit�t� ir j�p�riet uz mm no pikse�iem, ko dara izmantojot kalibr�cijas
% datus.

% Izmantojot vair�kus punktus, lai atrastu deltas nepiecie�ams piel�got erf
% funckiju. Ja ieg�st delta min un delta max var apr��in�t deltas vid�jo
% punktu (Xcenter) un deltas kop�jo platumu (Delta). Izmantojot �os
% lielumus var uzz�m�t erf l�kni taj�s pa��s koordin�t�s kur koncentr�cija.
% Izmantojot koncentr�cijas l�knes interv�lu sal�dzin�jumu
Xcenter = (dmax + dmin)/2
Delta = (dmax - dmin)/2
  (erf( (X -Xcenter)/ Delta )        +1)      /2);

%4) T� k� piel�dzin�t erf funckiju tikai p�c 2 punktiem rada nestabilit�ti
% datos, tad tiek izmantoti punkti interv�los 0.0786(+-)0.02 un 0.9214(+-)0.02
% T� k� dati da�reiz nav vienm�r interv�l� no 0-1, tad ��s v�rt�bas tiek
% scalotas atkar�b� no eso�aj� kadr� min un max koncentr�cijas.

%5) Nevienm�r�ga apgaismojuma d�� var rasties koncentr�cijas l�knes, kuras
%galos revers� virzienu, kam nevajadz�tu notikt. Izskaidrojums ir
%apgaismojums, kuram samazinoties st�ros att�ls k��st tum��ks. Viet�s, kur
%bija v�rojama ��da veida revers�cija tika �emta v�r� pirm� kadra maksim�l�
%vai minim�l� v�rt�ba �ajos punktos un v�l�kos kadros attiec�gi m�rogota.
% Piem�ram, ja 0-85 pikselis par�da lejupejo�o koncentr�ciju k� gad�ts,
% un 85-100 uzr�da aug�upejo�u, tad visiem kadriem 85-100 pikselis tiek
% m�rogots p�c pirm� kadra, bet p�rejiem nemain�gi.

%6) Visiem eksperimentiem tiek m�rogota koncentr�cija, lai pirmaj� kadr�
%b�tu interval� no 0-1, bet p�r�jiem tiek piel�gots p�c pirm� kadra skalas.

%7) Da�iem eksperimentiem bija v�rojams kritums delta vs Time grafik�
%noteiktos interv�los. Delta virziens �iem interv�liem bija �oti
%l�dz�gs k� p�r�jam grafikam, bet ar amplit�das nob�di. Tika uzskat�s, ka
%tas ir apgaismojuma mai�as d�� un nepiecie�ams kori��t datos, lai
%amplit�du sal�gotu ar p�rejo grafiku. Tas tika dar�ts manu�li atliekot 2
%punktus interv�la s�kumam un beig�m, un aizst�jot eso�os datus ar taisni +
%nelielu gausa troksni.
%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  