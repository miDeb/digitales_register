// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

const Map<String, String> schools = {
  "Kunstgymnasium und Landesberufsschule Cademia":
      "https://cademia.digitalesregister.it",
  "Cusanus Gymnasium Bruneck": "https://cusanus-gymnasium.digitalesregister.it",
  "FS Dietenheim": "https://fs-dietenheim.digitalesregister.it",
  "FS Tisens": "https://fstisens.digitalesregister.it",
  "Fachschule für Land- und Forstwirtschaft Fürstenburg Burgeis":
      "https://fs-fuerstenburg.digitalesregister.it",
  "Fachschule für Hauswirtschaft und Ernährung Kortsch":
      "https://fs-kortsch.digitalesregister.it",
  "Fachschule Laimburg": "https://fslaimburg.digitalesregister.it",
  "Fachschule Neumarkt": "https://fachschule-neumarkt.digitalesregister.it",
  "Oberschulen J. Ph. Fallmerayer": "https://fallmerayer.digitalesregister.it",
  "Fachoberschule für Wirtschaft, Grafik und Kommunikation (TFO/WFO Brixen)":
      "https://fo-brixen.digitalesregister.it",
  "FOS Meran": "https://fos-meran.digitalesregister.it",
  "Franziskanergymnasium Bozen":
      "https://franziskanergymnasium.digitalesregister.it",
  "Sozialwissenschaftliches Gymnasium Bruneck":
      "https://sowikunstgym-bruneck.digitalesregister.it",
  "Gymnasien Meran": "https://gymme.digitalesregister.it",
  "Gymnasium Walther von der Vogelweide Bozen":
      "https://vogelweide.digitalesregister.it",
  "Sozialwissenschaftliches Gymnasium JOSEF GASSER Brixen":
      "https://gymnasiumbrixen.digitalesregister.it",
  "Herzjesu Institut": "https://herzjesu-institut.digitalesregister.it",
  "WFO Raetia St. Ulrich": "https://ite-raetia.digitalesregister.it",
  "Landeshotelfachschule Kaiserhof Meran":
      "https://kaiserhof.digitalesregister.it",
  "GSP Klausen 1": "https://klausen1.digitalesregister.it",
  "GS Feldthurns": "https://feldthurns.digitalesregister.it",
  "GSS Klausen": "https://gssklausen2.digitalesregister.it",
  "Grundschule Kollmann": "https://kollmann.digitalesregister.it",
  "GS Verdings": "https://verdings.digitalesregister.it",
  "Villanders - Grundschulsprengel Klausen 2":
      "https://villanders.digitalesregister.it",
  "GS Waidbruck": "https://waidbruck.digitalesregister.it",
  "LBS Schlanders": "https://lbs-schlanders.digitalesregister.it",
  "LBS Zuegg": "https://lbszuegg.digitalesregister.it",
  "LHFS Bruneck": "https://lhfsbruneck.digitalesregister.it",
  "Scores altes La Ila": "https://scoresaltes.digitalesregister.it",
  "Mariengarten Zisterzienserinnen-KlosterInternatsschule":
      "https://mariengarten.digitalesregister.it",
  "Maria Hueber Gymnasium": "https://mhg.digitalesregister.it",
  "Mittelschule Klausen": "https://ms-klausen.digitalesregister.it",
  "MS Neumarkt": "https://ms-neumarkt.digitalesregister.it",
  "Oberschulzentrum Sterzing": "https://osz-sterzing.digitalesregister.it",
  "OFL Auer": "https://oflauer.digitalesregister.it",
  "WFO Auer": "https://wfoauer.digitalesregister.it",
  "Realgymnasium und Fachoberschule für Bauwesen „Peter Anich“ Bozen":
      "https://rg-fob.digitalesregister.it",
  "RG/TFO Albert Einstein Meran": "https://rgtfo-me.digitalesregister.it",
  "Grundschulsprengel Brixen": "https://brixen1.digitalesregister.it",
  "SSP Sarntal": "https://ssp-sarntal.digitalesregister.it",
  "GS Kastelruth": "https://gs-kastelruth.digitalesregister.it",
  "GS St. Michael": "https://gs-michael.digitalesregister.it",
  "GS St. Oswald": "https://gs-oswald.digitalesregister.it",
  "GS Seis": "https://gs-seis.digitalesregister.it",
  "GS Völs": "https://gs-voels.digitalesregister.it",
  "Schulsprengel Schlern": "https://sspschlern-ms.digitalesregister.it",
  "Grundschule Moos im Passeier": "https://gs-moos.digitalesregister.it",
  "Grundschule Platt in Passeier": "https://gs-platt.digitalesregister.it",
  "Grundschule Rabenstein in Passeier":
      "https://gs-rabenstein.digitalesregister.it",
  "Grundschule St. Leonhard": "https://gs-stleonhard.digitalesregister.it",
  "Grundschule Stuls in Passeier": "https://gs-stuls.digitalesregister.it",
  "Grundschule Walten in Passeier": "https://gs-walten.digitalesregister.it",
  "SSP St. Leonhard": "https://ssp-stleonhard.digitalesregister.it",
  "Mühlbach": "https://ssp-muehlbach.digitalesregister.it",
  "Grundschulen Sterzing III (Kematen, Mauls, St. Jakob, Stilfes, Trens, Wiesen)":
      "https://gs-sterzing3.digitalesregister.it",
  "SSP Sterzing 3 (Vigil Raber)":
      "https://schulsprengel-sterzing3.digitalesregister.it",
  "Grundschulen SSP Terlan": "https://gs-sspterlan.digitalesregister.it",
  "Mittelschule Terlan": "https://ms-sspterlan.digitalesregister.it",
  "Scola Mesana Selva": "https://sm-selva.digitalesregister.it",
  "Scola elementera Urtijei / Runcadic":
      "https://se-urtijei.digitalesregister.it",
  "Scola mesana Urtijëi": "https://sm-urtijei.digitalesregister.it",
  "Sozialwissenschaftliches Gymnasium Bozen - Fachoberschule für Tourismus":
      "https://sogym-fotour.digitalesregister.it",
  "SSP Abtei Scora elementara": "https://gs-abtei.digitalesregister.it",
  "SSP Abtei Scuola media \"Tita Alton\"":
      "https://ms-stern.digitalesregister.it",
  "Grundschule Ahrntal": "https://gs-ahrntal.digitalesregister.it",
  "Grundschule Luttach / Ahrntal": "https://gs-luttach.digitalesregister.it",
  "Grundschule Prettau / Ahrntal": "https://gs-prettau.digitalesregister.it",
  "Grundschule Steinhaus / Ahrntal":
      "https://gs-steinhaus.digitalesregister.it",
  "Grundschule St. Jakob / Ahrntal": "https://gs-stjakob.digitalesregister.it",
  "Grundschule St. Johann / Ahrntal":
      "https://gs-stjohann.digitalesregister.it",
  "Grundschule St. Peter / Ahrntal": "https://gs-stpeter.digitalesregister.it",
  "Grundschule Weissenbach / Ahrntal":
      "https://gs-weissenbach.digitalesregister.it",
  "SSP Ahrntal": "https://ssp-ahrntal.digitalesregister.it",
  "MS Algund": "https://ms-algund.digitalesregister.it",
  "SSP Algund - Grundschulen": "https://ssp-algund.digitalesregister.it",
  "Grundschulen SSP Bozen Europa (Grundschule J. H. Pestalozzi, Grundschule A. Langer)":
      "https://gs-bozeneuropa.digitalesregister.it",
  "Mittelschule SSP Bozen Europa (Mittelschule A. Schweitzer)":
      "https://ms-bozeneuropa.digitalesregister.it",
  "SSP Bruneck 1": "https://bruneck1.digitalesregister.it",
  "Mittelschule Bruneck II": "https://meusburger.digitalesregister.it",
  "Grundschulen im SSP Deutschnofen":
      "https://gs-deutschnofen.digitalesregister.it",
  "SSP Deutschnofen": "https://ssp-deutschnofen.digitalesregister.it",
  "Grundschule Frangart": "https://gs-frangart.digitalesregister.it",
  "Grundschule Girlan": "https://gs-girlan.digitalesregister.it",
  "Schulsprengel Eppan": "https://ssp-eppan.digitalesregister.it",
  "Grundschule Gries": "https://gs-gries.digitalesregister.it",
  "Mittelschule \"Adalbert Stifter\"":
      "https://ms-stifter.digitalesregister.it",
  "Grundschule Innichen": "https://gs-innichen.digitalesregister.it",
  "Grundschule Sexten": "https://gs-sexten.digitalesregister.it",
  "Grundschule Vierschach": "https://gs-vierschach.digitalesregister.it",
  "Grundschule Winnebach": "https://gs-winnebach.digitalesregister.it",
  "SSP Innichen": "https://ssp-innichen.digitalesregister.it",
  "Grundschulen SSP Karneid": "https://gs-sspkarneid.digitalesregister.it",
  "Mittelschule SSP Karneid": "https://ms-sspkarneid.digitalesregister.it",
  "SSP Lana": "https://ssp-lana.digitalesregister.it",
  "SSP Lana Grundschulen": "https://ssplana-gs.digitalesregister.it",
  "Grundschule Goldrain": "https://gs-goldrain.digitalesregister.it",
  "Grundschule Kastelbell": "https://gs-kastelbell.digitalesregister.it",
  "Grundschule Latsch": "https://gs-latsch.digitalesregister.it",
  "Grundschule Morter": "https://gs-morter.digitalesregister.it",
  "Grundschule Tarsch": "https://gs-tarsch.digitalesregister.it",
  "Grundschule Tschars": "https://gs-tschars.digitalesregister.it",
  "MS Latsch": "https://ms-latsch.digitalesregister.it",
  "GS Branzoll": "https://gs-branzoll.digitalesregister.it",
  "Grundschule Leifers": "https://gs-leifers.digitalesregister.it",
  "GS Pfatten": "https://gs-pfatten.digitalesregister.it",
  "GS St. Jakob (SSP Leifers)": "https://gs-st-jakob.digitalesregister.it",
  "Mittelschule Leifers": "https://ms-leifers.digitalesregister.it",
  "Mittelschule Mals": "https://ms-mals.digitalesregister.it",
  "Grundschulen SSP Mals": "https://sspmals-gs.digitalesregister.it",
  "Grundschulen SSP Obermais": "https://gs-ssp-obermais.digitalesregister.it",
  "GS Hafling": "https://hafling.digitalesregister.it",
  "SSP Meran Obermais": "https://ssp-meran-obermais.digitalesregister.it",
  "GS Albert Schweitzer": "https://gsalbertschweitzer.digitalesregister.it",
  "Grundschule Burgstall": "https://gsburgstall.digitalesregister.it",
  "Grundschule Franz Tappeiner":
      "https://gsfranztappeiner.digitalesregister.it",
  "Grundschule Oswald von Wolkenstein Meran":
      "https://gsoswaldvonwolkenstein.digitalesregister.it",
  "MS Carl Wolf": "https://mscarlwolf.digitalesregister.it",
  "Grundschulen SSP Untermais": "https://gs-untermais.digitalesregister.it",
  "MS Rosegger und Tirol": "https://ms-untermais.digitalesregister.it",
  "SSP Nonsberg Grundschule": "https://sspnonsberg-gs.digitalesregister.it",
  "SSP Nonsberg Mittelschule": "https://sspnonsberg-ms.digitalesregister.it",
  "Grundschule Geiselsberg": "https://gs-geiselsberg.digitalesregister.it",
  "Grundschule Mittertal": "https://gs-mittertal.digitalesregister.it",
  "Grundschule Niederolang": "https://gs-niederolang.digitalesregister.it",
  "Grundschule Niederrasen": "https://gs-niederrasen.digitalesregister.it",
  "Grundschule Niedertal": "https://gs-niedertal.digitalesregister.it",
  "Grundschule Oberolang": "https://gs-oberolang.digitalesregister.it",
  "Grundschule Oberrasen": "https://gs-oberrasen.digitalesregister.it",
  "Mittelschule Olang": "https://ssp-olang.digitalesregister.it",
  "Schulsprengel Ritten": "https://ssp-ritten.digitalesregister.it",
  "Grundschulen im SSP Schlanders":
      "https://gs-schlanders.digitalesregister.it",
  "Mittelschule Schlanders": "https://ms-schlanders.digitalesregister.it",
  "Grundschulen SSP Schluderns": "https://gs-schluderns.digitalesregister.it",
  "Mittelschule Schluderns": "https://ms-schluderns.digitalesregister.it",
  "Grundschule Saltaus / St. Martin": "https://gs-saltaus.digitalesregister.it",
  "Grundschule St. Martin": "https://gs-stm.digitalesregister.it",
  "Mittelschule St. Martin": "https://ssp-stm.digitalesregister.it",
  "GS Niederdorf": "https://gs-niederdorf.digitalesregister.it",
  "GS Prags": "https://gs-prags.digitalesregister.it",
  "Grundschule Toblach": "https://gs-toblach.digitalesregister.it",
  "GS Wahlen": "https://gs-wahlen.digitalesregister.it",
  "SSP Toblach": "https://ssp-toblach.digitalesregister.it",
  "Schulsprengel Tramin": "https://ssp-tramin.digitalesregister.it",
  "Grundschule Afing SSP Tschögglberg": "https://gs-afing.digitalesregister.it",
  "Grundschule Flaas SSP Tschögglberg": "https://gs-flaas.digitalesregister.it",
  "Grundschule Jenesien SSP Tschögglberg":
      "https://gs-jenesien.digitalesregister.it",
  "Grundschule Mölten SSP Tschögglberg":
      "https://gs-moelten.digitalesregister.it",
  "Grundschule Verschneid SSP Tschögglberg":
      "https://gs-verschneid.digitalesregister.it",
  "Grundschule Vöran SSP Tschögglberg":
      "https://gs-voeran.digitalesregister.it",
  "Mittelschule Jenesien": "https://ms-jenesien.digitalesregister.it",
  "Mittelschule Mölten": "https://ms-moelten.digitalesregister.it",
  "Grundschulen im Schulsprengel Ulten":
      "https://gs-ulten.digitalesregister.it",
  "SSP Ulten": "https://ssp-ulten.digitalesregister.it",
  "Schulsprengel Vintl": "https://ssp-vintl.digitalesregister.it",
  "MS Welsberg": "https://ms-welsberg.digitalesregister.it",
  "Schulsprengel Sterzing I (GS Sterzing J.Rampold, GS Gossensaß, MS Gossensaß, GS Innerpflersch)":
      "https://sterzing1.digitalesregister.it",
  "GS Ahornach": "https://gs-ahornach.digitalesregister.it",
  "GS Lappach": "https://gs-lappach.digitalesregister.it",
  "GS Mühlwald": "https://gs-muehlwald.digitalesregister.it",
  "GS Rein in Taufers": "https://gs-reinintaufers.digitalesregister.it",
  "GS Sand in Taufers": "https://gs-sandintaufers.digitalesregister.it",
  "Mittelschule Sand in Taufers": "https://ms-sand.digitalesregister.it",
  "OSZ Sand in Taufers": "https://sz-sand.digitalesregister.it",
  "TFO Bruneck": "https://tfo-bruneck.digitalesregister.it",
  "TFO Bozen": "https://tfobz.digitalesregister.it",
  "Ursulinen": "https://ursulinen.digitalesregister.it",
  "Vinzentinum": "https://vinzentinum.digitalesregister.it",
  "WFO Bozen": "https://wfobz.digitalesregister.it",
  "WFO Bruneck": "https://wfo-bruneck.digitalesregister.it",
  "WFO Meran": "https://wfokafka.digitalesregister.it",
  "GSP Lana": "https://gsp-lana.digitalesregister.it",
  "Grundschulen im Schulsprengel Laas": "https://gs-laas.digitalesregister.it",
  "Mittelschule Laas": "https://ms-laas.digitalesregister.it",
  "Grundschulsprengel Neumarkt": "https://gsp-neumarkt.digitalesregister.it",
  "Grundschulsprengel Bozen 1 (Goethe, Chini, Wolff)":
      "https://bozen1.digitalesregister.it",
  "Grundschulsprengel Eppan": "https://gspeppan.digitalesregister.it",
  "Grundschule Kaltern": "https://gs-kaltern.digitalesregister.it",
  "Waldorf WOB Bozen": "https://wob.digitalesregister.it",
  "Mittelschule Kaltern": "https://ms-kaltern.digitalesregister.it",
  "BBZ Bruneck": "https://bbz.digitalesregister.it",
  "Oberbozen (SSP Ritten)": "https://oberbozen.digitalesregister.it",
  "Wangen (SSP Ritten)": "https://wangen.digitalesregister.it",
  "GS Lengmoos (SSP Ritten)": "https://lengmoos.digitalesregister.it",
  "GS Oberinn (SSP Ritten)": "https://oberinn.digitalesregister.it",
  "GS Lengstein (SSP Ritten)": "https://lengstein.digitalesregister.it",
  "Unterinn (SSP Ritten)": "https://unterinn.digitalesregister.it",
  "OSZ Schlanders": "https://osz-schlanders.digitalesregister.it",
  "GS Vinzenz Goller (GSP Brixen)": "https://bx-goller.digitalesregister.it",
  "Mittelschule Oswald von Wolkenstein Brixen":
      "https://mittelschule-brixen.digitalesregister.it",
  "Mittelschule Naturns": "https://ms-naturns.digitalesregister.it",
  "Grundschule Marling": "https://gs-marling.digitalesregister.it",
  "Mittelschule Peter Rosegger":
      "https://ms-untermais.digitalesregister.it/v2/login",
};
