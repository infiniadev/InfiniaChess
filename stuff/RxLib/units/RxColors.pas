{*******************************************************}
{                                                       }
{         Delphi VCL Extensions (RX)                    }
{                                                       }
{         Copyright (c) 1997 Master-Bank                }
{                                                       }
{ Patched by Polaris Software                           }
{ Patched by Jouni Airaksinen                           }
{*******************************************************}

unit RxColors;

{$C PRELOAD}
{$I RX.INC}
{$DEFINE RX_COLOR_APPENDED}
interface

uses Classes, Controls, Graphics, Forms, RxVCLUtils;

function RxIdentToColor(const Ident: string; var Color: TColor): Boolean;
function RxColorToString(Color: TColor): string;
function RxStringToColor(S: string): TColor;
procedure RxGetColorValues(Proc: TGetStrProc); 

const
  clInfoBk16 = TColor($02E1FFFF);
  clNone16 = TColor($02FFFFFF);

  { Added colors }

  clWavePale = TColor($00D0D0D0);         { selected tab }
  clWaveDarkGray = TColor($00505050);     { borders }
  clWaveGray = TColor($00A0A0A0);         { menus, unselected tabs }
  clWaveLightGray = TColor($00BCBCBC);    { gray button }

  clWaveBeige = TColor($00B4C4C4);        { button face }
  clWaveBrightBeige = TColor($00BFFFFF);  { selected text }
  clWaveLightBeige = TColor($00D8E8E8);   { hotkey }

  clWaveCyan = TColor($00C4C4B4);         { button face }
  clWaveBrightCyan = TColor($00FFFFBF);   { selected text }
  clWaveLightCyan = TColor($00E8E8D8);    { hotkey }

  clWaveGreen = TColor($00B8BAB8);        { button face }
  clWaveBrightGreen = TColor($00CFFFCF);  { selected text }
  clWaveLightGreen = TColor($00DCE8DC);   { hotkey }

  clWaveViolet = TColor($02C4C2B8);       { button face }
  clWaveBrightViolet = TColor($02FFCFCF); { selected text }
  clWaveLightViolet = TColor($02E8DCDC);  { hotkey }

  { Standard Encarta & FlatStyle Color Constants }

  clRxDarkBlue = TColor($00996633);
  clRxBlue = TColor($00CF9030);
  clRxLightBlue = TColor($00CFB78F);

  clRxDarkRed = TColor($00302794);
  clRxRed = TColor($005F58B0);
  clRxLightRed = TColor($006963B6);

  clRxDarkGreen = TColor($00385937);
  clRxGreen = TColor($00518150);
  clRxLightGreen = TColor($0093CAB1);

  clRxDarkYellow = TColor($004EB6CF);
  clRxYellow = TColor($0057D1FF);
  clRxLightYellow = TColor($00B3F8FF);

  clRxDarkBrown = TColor($00394D4D);
  clRxBrown = TColor($00555E66);
  clRxLightBrown = TColor($00829AA2);

  clRxDarkKhaki = TColor($00D3D3D3);
  clRxKhaki = TColor($00C8D7D7);
  clRxLightKhaki = TColor($00E0E9EF);
  
  { added standard named html colors }
  clHtmBlack = TColor($00000000);
  clHtmGray0 = TColor($00171505);
  clHtmGray18 = TColor($00172505);
  clHtmGray21 = TColor($00172B1B);
  clHtmGray23 = TColor($00173022);
  clHtmGray24 = TColor($00263022);
  clHtmGray25 = TColor($00263428);
  clHtmGray26 = TColor($002C3428);
  clHtmGray27 = TColor($002C382D);
  clHtmGray28 = TColor($00313b31);
  clHtmGray29 = TColor($00353E35);
  clHtmGray30 = TColor($00394138);
  clHtmGray31 = TColor($003C4138);
  clHtmGray32 = TColor($003F463E);
  clHtmGray34 = TColor($00444A43);
  clHtmGray35 = TColor($00464C46);
  clHtmGray36 = TColor($00484E48);
  clHtmGray37 = TColor($004B504A);
  clHtmGray38 = TColor($004F544E);
  clHtmGray39 = TColor($00515650);
  clHtmGray40 = TColor($00545954);
  clHtmGray41 = TColor($00585C58);
  clHtmGray42 = TColor($00595F5A);
  clHtmGray43 = TColor($005D625D);
  clHtmGray44 = TColor($00606460);
  clHtmGray45 = TColor($00626663);
  clHtmGray46 = TColor($00656965);
  clHtmGray47 = TColor($00686D69);
  clHtmGray48 = TColor($006B6E6A);
  clHtmGray49 = TColor($006D726E);
  clHtmGray50 = TColor($00707471);
  clHtmGray = TColor($006E736F);
  clHtmSlateGray4 = TColor($007E616D);
  clHtmSlateGray = TColor($00836573);
  clHtmLightSteelBlue4 = TColor($007E646D);
  clHtmLightSlateGray = TColor($008D6D7B);
  clHtmCadetBlue4 = TColor($007E4C78);
  clHtmDarkSlateGray4 = TColor($007E4C7D);
  clHtmThistle4 = TColor($007E806D);
  clHtmMediumSlateBlue = TColor($00805E5A);
  clHtmMediumPurple4 = TColor($007E4E38);
  clHtmMidnightBlue = TColor($0054151B);
  clHtmDarkSlateBlue = TColor($00562B38);
  clHtmDarkSlateGray = TColor($003C2538);
  clHtmDimGray = TColor($0041463E);
  clHtmCornflowerBlue = TColor($008D151B);
  clHtmRoyalBlue4 = TColor($007E1531);
  clHtmSlateBlue4 = TColor($007E342D);
  clHtmRoyalBlue = TColor($00DE2B60);
  clHtmRoyalBlue1 = TColor($00FF306E);
  clHtmRoyalBlue2 = TColor($00EC2B65);
  clHtmRoyalBlue3 = TColor($00C72554);
  clHtmDeepSkyBlue = TColor($00FF3BB9);
  clHtmDeepSkyBlue2 = TColor($00EC38AC);
  clHtmSlateBlue = TColor($00C7357E);
  clHtmDeepSkyBlue3 = TColor($00C73090);
  clHtmDeepSkyBlue4 = TColor($007E2558);
  clHtmDodgerBlue = TColor($00FF1589);
  clHtmDodgerBlue2 = TColor($00EC157D);
  clHtmDodgerBlue3 = TColor($00C71569);
  clHtmDodgerBlue4 = TColor($007E153E);
  clHtmSteelBlue4 = TColor($007E2B54);
  clHtmSteelBlue = TColor($00A04863);
  clHtmSlateBlue2 = TColor($00EC6960);
  clHtmViolet = TColor($00C98D38);
  clHtmMediumPurple3 = TColor($00C77A5D);
  clHtmMediumPurple = TColor($00D78467);
  clHtmMediumPurple2 = TColor($00EC9172);
  clHtmMediumPurple1 = TColor($00FF9E7B);
  clHtmLightSteelBlue = TColor($00CE728F);
  clHtmSteelBlue3 = TColor($00C7488A);
  clHtmSteelBlue2 = TColor($00EC56A5);
  clHtmSteelBlue1 = TColor($00FF5CB3);
  clHtmSkyBlue3 = TColor($00C7659E);
  clHtmSkyBlue4 = TColor($007E4162);
  clHtmSlateBlue3 = TColor($00A1737C);
  clHtmSlateGray3 = TColor($00C798AF);
  clHtmVioletRed = TColor($008AF635);
  clHtmVioletRed1 = TColor($008AF635);
  clHtmVioletRed2 = TColor($007FE431);
  clHtmDeepPink = TColor($0087F528);
  clHtmDeepPink2 = TColor($007CE428);
  clHtmDeepPink3 = TColor($0067C122);
  clHtmDeepPink4 = TColor($003F7D05);
  clHtmMediumVioletRed = TColor($006BCA22);
  clHtmVioletRed3 = TColor($0069C128);
  clHtmFirebrick = TColor($00178005);
  clHtmVioletRed4 = TColor($00417D05);
  clHtmMaroon4 = TColor($00527D05);
  clHtmMaroon = TColor($00418105);
  clHtmMaroon3 = TColor($0083C122);
  clHtmMaroon2 = TColor($009DE331);
  clHtmMaroon1 = TColor($00AAF535);
  clHtmMagenta = TColor($00FFFF00);
  clHtmMagenta1 = TColor($00FFF433);
  clHtmMagenta2 = TColor($00ECE238);
  clHtmMagenta3 = TColor($00C7C031);
  clHtmMediumOrchid = TColor($00B5B048);
  clHtmMediumOrchid1 = TColor($00FFD462);
  clHtmMediumOrchid2 = TColor($00ECC45A);
  clHtmMediumOrchid3 = TColor($00C7A74A);
  clHtmMediumOrchid4 = TColor($007E6A28);
  clHtmPurple = TColor($00EF8E35);
  clHtmPurple1 = TColor($00FF893B);
  clHtmPurple2 = TColor($00EC7F38);
  clHtmPurple3 = TColor($00C76C2D);
  clHtmPurple4 = TColor($007E461B);
  clHtmDarkOrchid4 = TColor($007e571B);
  clHtmDarkOrchid = TColor($007E7D1B);
  clHtmDarkViolet = TColor($00CE842D);
  clHtmDarkOrchid3 = TColor($00C78B31);
  clHtmDarkOrchid2 = TColor($00ECA23B);
  clHtmDarkOrchid1 = TColor($00FFB041);
  clHtmPlum4 = TColor($007E7E58);
  clHtmPaleVioletRed = TColor($0087D165);
  clHtmPaleVioletRed1 = TColor($00A1F778);
  clHtmPaleVioletRed2 = TColor($0094E56E);
  clHtmPaleVioletRed3 = TColor($007CC25A);
  clHtmPaleVioletRed4 = TColor($004D7E35);
  clHtmPlum = TColor($008FB93B);
  clHtmPlum1 = TColor($00FFF9B7);
  clHtmPlum2 = TColor($00ECE6A9);
  clHtmPlum3 = TColor($00C7C38E);
  clHtmThistle = TColor($00D3D2B9);
  clHtmThistle3 = TColor($00C7C6AE);
  clHtmLavenderBlush2 = TColor($00E2EBDD);
  clHtmLavenderBlush3 = TColor($00BEC8BB);
  clHtmThistle2 = TColor($00ECE9CF);
  clHtmThistle1 = TColor($00FFFCDF);
  clHtmLavender = TColor($00FAE3E4);
  clHtmLavenderBlush = TColor($00F4FDEE);
  clHtmLightSteelBlue1 = TColor($00FFC6DE);
  clHtmLightBlue = TColor($00FFADDF);
  clHtmLightBlue1 = TColor($00FFBDED);
  clHtmLightCyan = TColor($00FFE0FF);
  clHtmSlateGray1 = TColor($00FFC2DF);
  clHtmSlateGray2 = TColor($00ECB4CF);
  clHtmLightSteelBlue2 = TColor($00ECB7CE);
  clHtmTurquoise1 = TColor($00FF52F3);
  clHtmCyan = TColor($00FF00FF);
  clHtmCyan1 = TColor($00FF57FE);
  clHtmCyan2 = TColor($00EC50EB);
  clHtmTurquoise2 = TColor($00EC4EE2);
  clHtmMediumTurquoise = TColor($00CD48CC);
  clHtmTurquoise = TColor($00DB43C6);
  clHtmDarkSlateGray1 = TColor($00FF9AFE);
  clHtmDarkSlateGray2 = TColor($00EC8EEB);
  clHtmDarkSlateGray3 = TColor($00c778c7);
  clHtmCyan3 = TColor($00C746C7);
  clHtmTurquoise3 = TColor($00C743BF);
  clHtmCadetBlue3 = TColor($00C777BF);
  clHtmPaleTurquoise3 = TColor($00C792C7);
  clHtmLightBlue2 = TColor($00ECAFDC);
  clHtmDarkTurquoise = TColor($009C3B9C);
  clHtmCyan4 = TColor($007E307D);
  clHtmLightSeaGreen = TColor($009F3EA9);
  clHtmLightSkyBlue = TColor($00FA82CA);
  clHtmLightSkyBlue2 = TColor($00ECA0CF);
  clHtmLightSkyBlue3 = TColor($00C787AF);
  clHtmSkyBlue = TColor($00FF82CA);
  clHtmSkyBlue2 = TColor($00EC79BA);
  clHtmLightSkyBlue4 = TColor($007E566D);
  clHtmSkyBlue5 = TColor($00FF6698);
  clHtmLightSlateBlue = TColor($00FF736A);
  clHtmLightCyan2 = TColor($00ECCFEC);
  clHtmLightCyan3 = TColor($00C7AFC7);
  clHtmLightCyan4 = TColor($007D717D);
  clHtmLightBlue3 = TColor($00C795B9);
  clHtmLightBlue4 = TColor($007E5E76);
  clHtmPaleTurquoise4 = TColor($007E5E7D);
  clHtmDarkSeaGreen4 = TColor($0058617C);
  clHtmMediumAquamarine = TColor($00813487);
  clHtmMediumSeaGreen = TColor($00543067);
  clHtmSeaGreen = TColor($00754E89);
  clHtmDarkGreen = TColor($00172541);
  clHtmSeaGreen4 = TColor($0044387C);
  clHtmForestGreen = TColor($00584E92);
  clHtmMediumForestGreen = TColor($00353472);
  clHtmSpringGreen4 = TColor($002C347C);
  clHtmDarkOliveGreen4 = TColor($0026667C);
  clHtmChartreuse4 = TColor($0017437C);
  clHtmGreen4 = TColor($0017347C);
  clHtmMediumSpringGreen = TColor($00173480);
  clHtmSpringGreen = TColor($002C4AA0);
  clHtmLimeGreen = TColor($001741A3);
  clHtmDarkSeaGreen = TColor($00818BB3);
  clHtmDarkSeaGreen3 = TColor($008E99C6);
  clHtmGreen3 = TColor($00174CC4);
  clHtmChartreuse3 = TColor($00176CC4);
  clHtmYellowGreen = TColor($001752D0);
  clHtmSpringGreen3 = TColor($00524CC5);
  clHtmSeaGreen3 = TColor($007154C5);
  clHtmSpringGreen2 = TColor($006457E9);
  clHtmSpringGreen1 = TColor($006E5EFB);
  clHtmSeaGreen2 = TColor($008664E9);
  clHtmSeaGreen1 = TColor($00926AFB);
  clHtmDarkSeaGreen2 = TColor($00AAB5EA);
  clHtmDarkSeaGreen1 = TColor($00B8C3FD);
  clHtmGreen = TColor($000000FF);
  clHtmLawnGreen = TColor($001787F7);
  clHtmGreen1 = TColor($00175FFB);
  clHtmGreen2 = TColor($001759E8);
  clHtmChartreuse2 = TColor($00177FE8);
  clHtmChartreuse = TColor($00178AFB);
  clHtmGreenYellow = TColor($0017B1FB);
  clHtmDarkOliveGreen1 = TColor($005DCCFB);
  clHtmDarkOliveGreen2 = TColor($0054BCE9);
  clHtmDarkOliveGreen3 = TColor($0044A0C5);
  clHtmYellow = TColor($0000FFFF);
  clHtmYellow1 = TColor($0017FFFC);
  clHtmKhaki1 = TColor($0080FFF3);
  clHtmKhaki2 = TColor($0075EDE2);
  clHtmGoldenrod = TColor($0074EDDA);
  clHtmGold2 = TColor($0017EAC1);
  clHtmGold1 = TColor($0017FDD0);
  clHtmGoldenrod1 = TColor($0017FBB9);
  clHtmGoldenrod2 = TColor($0017E9AB);
  clHtmGold = TColor($0017D4A0);
  clHtmGold3 = TColor($0017C7A3);
  clHtmGoldenrod3 = TColor($0017C68E);
  clHtmDarkGoldenrod = TColor($0017AF78);
  clHtmKhaki = TColor($006EADA9);
  clHtmKhaki3 = TColor($0062C9BE);
  clHtmKhaki4 = TColor($00398278);
  clHtmDarkGoldenrod1 = TColor($0017FBB1);
  clHtmDarkGoldenrod2 = TColor($0017E8A3);
  clHtmDarkGoldenrod3 = TColor($0017C589);
  clHtmSienna1 = TColor($0031F874);
  clHtmSienna2 = TColor($002CE66C);
  clHtmDarkOrange = TColor($0017F880);
  clHtmDarkOrange1 = TColor($0017F872);
  clHtmDarkOrange2 = TColor($0017E567);
  clHtmDarkOrange3 = TColor($0017C356);
  clHtmSienna3 = TColor($0017C358);
  clHtmSienna = TColor($00178A41);
  clHtmSienna4 = TColor($00177E35);
  clHtmIndianRed4 = TColor($00177E22);
  clHtmDarkOrange4 = TColor($00177E31);
  clHtmSalmon4 = TColor($00177E38);
  clHtmDarkGoldenrod4 = TColor($00177F52);
  clHtmGold4 = TColor($00178065);
  clHtmGoldenrod4 = TColor($00178058);
  clHtmLightSalmon4 = TColor($002C7F46);
  clHtmChocolate = TColor($0017C85A);
  clHtmCoral3 = TColor($002CC34A);
  clHtmCoral2 = TColor($003CE55B);
  clHtmCoral = TColor($0041F765);
  clHtmDarkSalmon = TColor($006BE18B);
  clHtmSalmon1 = TColor($0058F881);
  clHtmSalmon2 = TColor($0051E674);
  clHtmSalmon3 = TColor($0041C362);
  clHtmLightSalmon3 = TColor($0051C474);
  clHtmLightSalmon2 = TColor($0061E78A);
  clHtmLightSalmon = TColor($006BF996);
  clHtmSandyBrown = TColor($004DEE9A);
  clHtmHotPink = TColor($00ABF660);
  clHtmHotPink1 = TColor($00ABF665);
  clHtmHotPink2 = TColor($009DE45E);
  clHtmHotPink3 = TColor($0083C252);
  clHtmHotPink4 = TColor($00527D22);
  clHtmLightCoral = TColor($0071E774);
  clHtmIndianRed1 = TColor($0059F75D);
  clHtmIndianRed2 = TColor($0051E554);
  clHtmIndianRed3 = TColor($0041C246);
  clHtmRed = TColor($0000FF00);
  clHtmRed1 = TColor($0017F622);
  clHtmRed2 = TColor($0017E41B);
  clHtmFirebrick1 = TColor($0017F628);
  clHtmFirebrick2 = TColor($0017E422);
  clHtmFirebrick3 = TColor($0017C11B);
  clHtmPink = TColor($00BEFAAF);
  clHtmRosyBrown1 = TColor($00B9FBBB);
  clHtmRosyBrown2 = TColor($00AAE8AD);
  clHtmPink2 = TColor($00B0E7A1);
  clHtmLightPink = TColor($00BAFAAF);
  clHtmLightPink1 = TColor($00B0F9A7);
  clHtmLightPink2 = TColor($00A3E799);
  clHtmPink3 = TColor($0093C487);
  clHtmRosyBrown3 = TColor($008EC590);
  clHtmRosyBrown = TColor($0081B384);
  clHtmLightPink3 = TColor($0089C481);
  clHtmRosyBrown4 = TColor($00587F5A);
  clHtmLightPink4 = TColor($00527F4E);
  clHtmPink4 = TColor($005D7F52);
  clHtmLavenderBlush4 = TColor($00798176);
  clHtmLightGoldenrod4 = TColor($00398173);
  clHtmLemonChiffon4 = TColor($0060827B);
  clHtmLemonChiffon3 = TColor($0099C9C2);
  clHtmLightGoldenrod3 = TColor($0060C8B5);
  clHtmLightGolden2 = TColor($0072ECD6);
  clHtmLightGoldenrod = TColor($0072ECD8);
  clHtmLightGoldenrod1 = TColor($007CFFE8);
  clHtmLemonChiffon2 = TColor($00B6ECE5);
  clHtmLemonChiffon = TColor($00C6FFF8);
  clHtmLightGoldenrodYellow = TColor($00CCFAF8);

implementation

uses
  {$IFDEF RX_D5}Windows, {$ENDIF}SysUtils; // Polaris

type
  TColorEntry = record
    Value: TColor;
    Name: PChar;
  end;

const
  ColorCount = 3 {$IFDEF RX_COLOR_APPENDED}+ 34 + 295{$ENDIF};

  Colors: array[0..ColorCount - 1] of TColorEntry = (

    (Value: clCream; Name: 'clCream'),
    (Value: clMoneyGreen; Name: 'clMoneyGreen'),
    (Value: clSkyBlue; Name: 'clSkyBlue')
    {$IFDEF RX_COLOR_APPENDED},
    { added colors }

    (Value: clWavePale; Name: 'clWavePale'),
    (Value: clWaveDarkGray; Name: 'clWaveDarkGray'),
    (Value: clWaveGray; Name: 'clWaveGray'),
    (Value: clWaveLightGray; Name: 'clWaveLightGray'),

    (Value: clWaveBeige; Name: 'clWaveBeige'),
    (Value: clWaveBrightBeige; Name: 'clWaveBrightBeige'),
    (Value: clWaveLightBeige; Name: 'clWaveLightBeige'),

    (Value: clWaveCyan; Name: 'clWaveCyan'),
    (Value: clWaveBrightCyan; Name: 'clWaveBrightCyan'),
    (Value: clWaveLightCyan; Name: 'clWaveLightCyan'),

    (Value: clWaveGreen; Name: 'clWaveGreen'),
    (Value: clWaveBrightGreen; Name: 'clWaveBrightGreen'),
    (Value: clWaveLightGreen; Name: 'clWaveLightGreen'),

    (Value: clWaveViolet; Name: 'clWaveViolet'),
    (Value: clWaveBrightViolet; Name: 'clWaveBrightViolet'),
    (Value: clWaveLightViolet; Name: 'clWaveLightViolet'),

    { Standard Encarta & FlatStyle Color Constants }

    (Value: clRxDarkBlue; Name: 'clRxDarkBlue'),
    (Value: clRxBlue; Name: 'clRxBlue'),
    (Value: clRxLightBlue; Name: 'clRxLightBlue'),

    (Value: clRxDarkRed; Name: 'clRxDarkRed'),
    (Value: clRxRed; Name: 'clRxRed'),
    (Value: clRxLightRed; Name: 'clRxLightRed'),

    (Value: clRxDarkGreen; Name: 'clRxDarkGreen'),
    (Value: clRxGreen; Name: 'clRxGreen'),
    (Value: clRxLightGreen; Name: 'clRxLightGreen'),

    (Value: clRxDarkYellow; Name: 'clRxDarkYellow'),
    (Value: clRxYellow; Name: 'clRxYellow'),
    (Value: clRxLightYellow; Name: 'clRxLightYellow'),

    (Value: clRxDarkBrown; Name: 'clRxDarkBrown'),
    (Value: clRxBrown; Name: 'clRxBrown'),
    (Value: clRxLightBrown; Name: 'clRxLightBrown'),

    (Value: clRxDarkKhaki; Name: 'clRxDarkKhaki'),
    (Value: clRxKhaki; Name: 'clRxKhaki'),
    (Value: clRxLightKhaki; Name: 'clRxLightKhaki'),
    
    { added standard named html colors }
    (Value: clHtmBlack; Name: 'clHtmBlack'),
    (Value: clHtmGray0; Name: 'clHtmGray0'),
    (Value: clHtmGray18; Name: 'clHtmGray18'),
    (Value: clHtmGray21; Name: 'clHtmGray21'),
    (Value: clHtmGray23; Name: 'clHtmGray23'),
    (Value: clHtmGray24; Name: 'clHtmGray24'),
    (Value: clHtmGray25; Name: 'clHtmGray25'),
    (Value: clHtmGray26; Name: 'clHtmGray26'),
    (Value: clHtmGray27; Name: 'clHtmGray27'),
    (Value: clHtmGray28; Name: 'clHtmGray28'),
    (Value: clHtmGray29; Name: 'clHtmGray29'),
    (Value: clHtmGray30; Name: 'clHtmGray30'),
    (Value: clHtmGray31; Name: 'clHtmGray31'),
    (Value: clHtmGray32; Name: 'clHtmGray32'),
    (Value: clHtmGray34; Name: 'clHtmGray34'),
    (Value: clHtmGray35; Name: 'clHtmGray35'),
    (Value: clHtmGray36; Name: 'clHtmGray36'),
    (Value: clHtmGray37; Name: 'clHtmGray37'),
    (Value: clHtmGray38; Name: 'clHtmGray38'),
    (Value: clHtmGray39; Name: 'clHtmGray39'),
    (Value: clHtmGray40; Name: 'clHtmGray40'),
    (Value: clHtmGray41; Name: 'clHtmGray41'),
    (Value: clHtmGray42; Name: 'clHtmGray42'),
    (Value: clHtmGray43; Name: 'clHtmGray43'),
    (Value: clHtmGray44; Name: 'clHtmGray44'),
    (Value: clHtmGray45; Name: 'clHtmGray45'),
    (Value: clHtmGray46; Name: 'clHtmGray46'),
    (Value: clHtmGray47; Name: 'clHtmGray47'),
    (Value: clHtmGray48; Name: 'clHtmGray48'),
    (Value: clHtmGray49; Name: 'clHtmGray49'),
    (Value: clHtmGray50; Name: 'clHtmGray50'),
    (Value: clHtmGray; Name: 'clHtmGray'),
    (Value: clHtmSlateGray4; Name: 'clHtmSlateGray4'),
    (Value: clHtmSlateGray; Name: 'clHtmSlateGray'),
    (Value: clHtmLightSteelBlue4; Name: 'clHtmLightSteelBlue4'),
    (Value: clHtmLightSlateGray; Name: 'clHtmLightSlateGray'),
    (Value: clHtmCadetBlue4; Name: 'clHtmCadetBlue4'),
    (Value: clHtmDarkSlateGray4; Name: 'clHtmDarkSlateGray4'),
    (Value: clHtmThistle4; Name: 'clHtmThistle4'),
    (Value: clHtmMediumSlateBlue; Name: 'clHtmMediumSlateBlue'),
    (Value: clHtmMediumPurple4; Name: 'clHtmMediumPurple4'),
    (Value: clHtmMidnightBlue; Name: 'clHtmMidnightBlue'),
    (Value: clHtmDarkSlateBlue; Name: 'clHtmDarkSlateBlue'),
    (Value: clHtmDarkSlateGray; Name: 'clHtmDarkSlateGray'),
    (Value: clHtmDimGray; Name: 'clHtmDimGray'),
    (Value: clHtmCornflowerBlue; Name: 'clHtmCornflowerBlue'),
    (Value: clHtmRoyalBlue4; Name: 'clHtmRoyalBlue4'),
    (Value: clHtmSlateBlue4; Name: 'clHtmSlateBlue4'),
    (Value: clHtmRoyalBlue; Name: 'clHtmRoyalBlue'),
    (Value: clHtmRoyalBlue1; Name: 'clHtmRoyalBlue1'),
    (Value: clHtmRoyalBlue2; Name: 'clHtmRoyalBlue2'),
    (Value: clHtmRoyalBlue3; Name: 'clHtmRoyalBlue3'),
    (Value: clHtmDeepSkyBlue; Name: 'clHtmDeepSkyBlue'),
    (Value: clHtmDeepSkyBlue2; Name: 'clHtmDeepSkyBlue2'),
    (Value: clHtmSlateBlue; Name: 'clHtmSlateBlue'),
    (Value: clHtmDeepSkyBlue3; Name: 'clHtmDeepSkyBlue3'),
    (Value: clHtmDeepSkyBlue4; Name: 'clHtmDeepSkyBlue4'),
    (Value: clHtmDodgerBlue; Name: 'clHtmDodgerBlue'),
    (Value: clHtmDodgerBlue2; Name: 'clHtmDodgerBlue2'),
    (Value: clHtmDodgerBlue3; Name: 'clHtmDodgerBlue3'),
    (Value: clHtmDodgerBlue4; Name: 'clHtmDodgerBlue4'),
    (Value: clHtmSteelBlue4; Name: 'clHtmSteelBlue4'),
    (Value: clHtmSteelBlue; Name: 'clHtmSteelBlue'),
    (Value: clHtmSlateBlue2; Name: 'clHtmSlateBlue2'),
    (Value: clHtmViolet; Name: 'clHtmViolet'),
    (Value: clHtmMediumPurple3; Name: 'clHtmMediumPurple3'),
    (Value: clHtmMediumPurple; Name: 'clHtmMediumPurple'),
    (Value: clHtmMediumPurple2; Name: 'clHtmMediumPurple2'),
    (Value: clHtmMediumPurple1; Name: 'clHtmMediumPurple1'),
    (Value: clHtmLightSteelBlue; Name: 'clHtmLightSteelBlue'),
    (Value: clHtmSteelBlue3; Name: 'clHtmSteelBlue3'),
    (Value: clHtmSteelBlue2; Name: 'clHtmSteelBlue2'),
    (Value: clHtmSteelBlue1; Name: 'clHtmSteelBlue1'),
    (Value: clHtmSkyBlue3; Name: 'clHtmSkyBlue3'),
    (Value: clHtmSkyBlue4; Name: 'clHtmSkyBlue4'),
    (Value: clHtmSlateBlue3; Name: 'clHtmSlateBlue3'),
    (Value: clHtmSlateGray3; Name: 'clHtmSlateGray3'),
    (Value: clHtmVioletRed; Name: 'clHtmVioletRed'),
    (Value: clHtmVioletRed1; Name: 'clHtmVioletRed1'),
    (Value: clHtmVioletRed2; Name: 'clHtmVioletRed2'),
    (Value: clHtmDeepPink; Name: 'clHtmDeepPink'),
    (Value: clHtmDeepPink2; Name: 'clHtmDeepPink2'),
    (Value: clHtmDeepPink3; Name: 'clHtmDeepPink3'),
    (Value: clHtmDeepPink4; Name: 'clHtmDeepPink4'),
    (Value: clHtmMediumVioletRed; Name: 'clHtmMediumVioletRed'),
    (Value: clHtmVioletRed3; Name: 'clHtmVioletRed3'),
    (Value: clHtmFirebrick; Name: 'clHtmFirebrick'),
    (Value: clHtmVioletRed4; Name: 'clHtmVioletRed4'),
    (Value: clHtmMaroon4; Name: 'clHtmMaroon4'),
    (Value: clHtmMaroon; Name: 'clHtmMaroon'),
    (Value: clHtmMaroon3; Name: 'clHtmMaroon3'),
    (Value: clHtmMaroon2; Name: 'clHtmMaroon2'),
    (Value: clHtmMaroon1; Name: 'clHtmMaroon1'),
    (Value: clHtmMagenta; Name: 'clHtmMagenta'),
    (Value: clHtmMagenta1; Name: 'clHtmMagenta1'),
    (Value: clHtmMagenta2; Name: 'clHtmMagenta2'),
    (Value: clHtmMagenta3; Name: 'clHtmMagenta3'),
    (Value: clHtmMediumOrchid; Name: 'clHtmMediumOrchid'),
    (Value: clHtmMediumOrchid1; Name: 'clHtmMediumOrchid1'),
    (Value: clHtmMediumOrchid2; Name: 'clHtmMediumOrchid2'),
    (Value: clHtmMediumOrchid3; Name: 'clHtmMediumOrchid3'),
    (Value: clHtmMediumOrchid4; Name: 'clHtmMediumOrchid4'),
    (Value: clHtmPurple; Name: 'clHtmPurple'),
    (Value: clHtmPurple1; Name: 'clHtmPurple1'),
    (Value: clHtmPurple2; Name: 'clHtmPurple2'),
    (Value: clHtmPurple3; Name: 'clHtmPurple3'),
    (Value: clHtmPurple4; Name: 'clHtmPurple4'),
    (Value: clHtmDarkOrchid4; Name: 'clHtmDarkOrchid4'),
    (Value: clHtmDarkOrchid; Name: 'clHtmDarkOrchid'),
    (Value: clHtmDarkViolet; Name: 'clHtmDarkViolet'),
    (Value: clHtmDarkOrchid3; Name: 'clHtmDarkOrchid3'),
    (Value: clHtmDarkOrchid2; Name: 'clHtmDarkOrchid2'),
    (Value: clHtmDarkOrchid1; Name: 'clHtmDarkOrchid1'),
    (Value: clHtmPlum4; Name: 'clHtmPlum4'),
    (Value: clHtmPaleVioletRed; Name: 'clHtmPaleVioletRed'),
    (Value: clHtmPaleVioletRed1; Name: 'clHtmPaleVioletRed1'),
    (Value: clHtmPaleVioletRed2; Name: 'clHtmPaleVioletRed2'),
    (Value: clHtmPaleVioletRed3; Name: 'clHtmPaleVioletRed3'),
    (Value: clHtmPaleVioletRed4; Name: 'clHtmPaleVioletRed4'),
    (Value: clHtmPlum; Name: 'clHtmPlum'),
    (Value: clHtmPlum1; Name: 'clHtmPlum1'),
    (Value: clHtmPlum2; Name: 'clHtmPlum2'),
    (Value: clHtmPlum3; Name: 'clHtmPlum3'),
    (Value: clHtmThistle; Name: 'clHtmThistle'),
    (Value: clHtmThistle3; Name: 'clHtmThistle3'),
    (Value: clHtmLavenderBlush2; Name: 'clHtmLavenderBlush2'),
    (Value: clHtmLavenderBlush3; Name: 'clHtmLavenderBlush3'),
    (Value: clHtmThistle2; Name: 'clHtmThistle2'),
    (Value: clHtmThistle1; Name: 'clHtmThistle1'),
    (Value: clHtmLavender; Name: 'clHtmLavender'),
    (Value: clHtmLavenderBlush; Name: 'clHtmLavenderBlush'),
    (Value: clHtmLightSteelBlue1; Name: 'clHtmLightSteelBlue1'),
    (Value: clHtmLightBlue; Name: 'clHtmLightBlue'),
    (Value: clHtmLightBlue1; Name: 'clHtmLightBlue1'),
    (Value: clHtmLightCyan; Name: 'clHtmLightCyan'),
    (Value: clHtmSlateGray1; Name: 'clHtmSlateGray1'),
    (Value: clHtmSlateGray2; Name: 'clHtmSlateGray2'),
    (Value: clHtmLightSteelBlue2; Name: 'clHtmLightSteelBlue2'),
    (Value: clHtmTurquoise1; Name: 'clHtmTurquoise1'),
    (Value: clHtmCyan; Name: 'clHtmCyan'),
    (Value: clHtmCyan1; Name: 'clHtmCyan1'),
    (Value: clHtmCyan2; Name: 'clHtmCyan2'),
    (Value: clHtmTurquoise2; Name: 'clHtmTurquoise2'),
    (Value: clHtmMediumTurquoise; Name: 'clHtmMediumTurquoise'),
    (Value: clHtmTurquoise; Name: 'clHtmTurquoise'),
    (Value: clHtmDarkSlateGray1; Name: 'clHtmDarkSlateGray1'),
    (Value: clHtmDarkSlateGray2; Name: 'clHtmDarkSlateGray2'),
    (Value: clHtmDarkSlateGray3; Name: 'clHtmDarkSlateGray3'),
    (Value: clHtmCyan3; Name: 'clHtmCyan3'),
    (Value: clHtmTurquoise3; Name: 'clHtmTurquoise3'),
    (Value: clHtmCadetBlue3; Name: 'clHtmCadetBlue3'),
    (Value: clHtmPaleTurquoise3; Name: 'clHtmPaleTurquoise3'),
    (Value: clHtmLightBlue2; Name: 'clHtmLightBlue2'),
    (Value: clHtmDarkTurquoise; Name: 'clHtmDarkTurquoise'),
    (Value: clHtmCyan4; Name: 'clHtmCyan4'),
    (Value: clHtmLightSeaGreen; Name: 'clHtmLightSeaGreen'),
    (Value: clHtmLightSkyBlue; Name: 'clHtmLightSkyBlue'),
    (Value: clHtmLightSkyBlue2; Name: 'clHtmLightSkyBlue2'),
    (Value: clHtmLightSkyBlue3; Name: 'clHtmLightSkyBlue3'),
    (Value: clHtmSkyBlue; Name: 'clHtmSkyBlue'),
    (Value: clHtmSkyBlue2; Name: 'clHtmSkyBlue2'),
    (Value: clHtmLightSkyBlue4; Name: 'clHtmLightSkyBlue4'),
    (Value: clHtmSkyBlue5; Name: 'clHtmSkyBlue5'),
    (Value: clHtmLightSlateBlue; Name: 'clHtmLightSlateBlue'),
    (Value: clHtmLightCyan2; Name: 'clHtmLightCyan2'),
    (Value: clHtmLightCyan3; Name: 'clHtmLightCyan3'),
    (Value: clHtmLightCyan4; Name: 'clHtmLightCyan4'),
    (Value: clHtmLightBlue3; Name: 'clHtmLightBlue3'),
    (Value: clHtmLightBlue4; Name: 'clHtmLightBlue4'),
    (Value: clHtmPaleTurquoise4; Name: 'clHtmPaleTurquoise4'),
    (Value: clHtmDarkSeaGreen4; Name: 'clHtmDarkSeaGreen4'),
    (Value: clHtmMediumAquamarine; Name: 'clHtmMediumAquamarine'),
    (Value: clHtmMediumSeaGreen; Name: 'clHtmMediumSeaGreen'),
    (Value: clHtmSeaGreen; Name: 'clHtmSeaGreen'),
    (Value: clHtmDarkGreen; Name: 'clHtmDarkGreen'),
    (Value: clHtmSeaGreen4; Name: 'clHtmSeaGreen4'),
    (Value: clHtmForestGreen; Name: 'clHtmForestGreen'),
    (Value: clHtmMediumForestGreen; Name: 'clHtmMediumForestGreen'),
    (Value: clHtmSpringGreen4; Name: 'clHtmSpringGreen4'),
    (Value: clHtmDarkOliveGreen4; Name: 'clHtmDarkOliveGreen4'),
    (Value: clHtmChartreuse4; Name: 'clHtmChartreuse4'),
    (Value: clHtmGreen4; Name: 'clHtmGreen4'),
    (Value: clHtmMediumSpringGreen; Name: 'clHtmMediumSpringGreen'),
    (Value: clHtmSpringGreen; Name: 'clHtmSpringGreen'),
    (Value: clHtmLimeGreen; Name: 'clHtmLimeGreen'),
    (Value: clHtmDarkSeaGreen; Name: 'clHtmDarkSeaGreen'),
    (Value: clHtmDarkSeaGreen3; Name: 'clHtmDarkSeaGreen3'),
    (Value: clHtmGreen3; Name: 'clHtmGreen3'),
    (Value: clHtmChartreuse3; Name: 'clHtmChartreuse3'),
    (Value: clHtmYellowGreen; Name: 'clHtmYellowGreen'),
    (Value: clHtmSpringGreen3; Name: 'clHtmSpringGreen3'),
    (Value: clHtmSeaGreen3; Name: 'clHtmSeaGreen3'),
    (Value: clHtmSpringGreen2; Name: 'clHtmSpringGreen2'),
    (Value: clHtmSpringGreen1; Name: 'clHtmSpringGreen1'),
    (Value: clHtmSeaGreen2; Name: 'clHtmSeaGreen2'),
    (Value: clHtmSeaGreen1; Name: 'clHtmSeaGreen1'),
    (Value: clHtmDarkSeaGreen2; Name: 'clHtmDarkSeaGreen2'),
    (Value: clHtmDarkSeaGreen1; Name: 'clHtmDarkSeaGreen1'),
    (Value: clHtmGreen; Name: 'clHtmGreen'),
    (Value: clHtmLawnGreen; Name: 'clHtmLawnGreen'),
    (Value: clHtmGreen1; Name: 'clHtmGreen1'),
    (Value: clHtmGreen2; Name: 'clHtmGreen2'),
    (Value: clHtmChartreuse2; Name: 'clHtmChartreuse2'),
    (Value: clHtmChartreuse; Name: 'clHtmChartreuse'),
    (Value: clHtmGreenYellow; Name: 'clHtmGreenYellow'),
    (Value: clHtmDarkOliveGreen1; Name: 'clHtmDarkOliveGreen1'),
    (Value: clHtmDarkOliveGreen2; Name: 'clHtmDarkOliveGreen2'),
    (Value: clHtmDarkOliveGreen3; Name: 'clHtmDarkOliveGreen3'),
    (Value: clHtmYellow; Name: 'clHtmYellow'),
    (Value: clHtmYellow1; Name: 'clHtmYellow1'),
    (Value: clHtmKhaki1; Name: 'clHtmKhaki1'),
    (Value: clHtmKhaki2; Name: 'clHtmKhaki2'),
    (Value: clHtmGoldenrod; Name: 'clHtmGoldenrod'),
    (Value: clHtmGold2; Name: 'clHtmGold2'),
    (Value: clHtmGold1; Name: 'clHtmGold1'),
    (Value: clHtmGoldenrod1; Name: 'clHtmGoldenrod1'),
    (Value: clHtmGoldenrod2; Name: 'clHtmGoldenrod2'),
    (Value: clHtmGold; Name: 'clHtmGold'),
    (Value: clHtmGold3; Name: 'clHtmGold3'),
    (Value: clHtmGoldenrod3; Name: 'clHtmGoldenrod3'),
    (Value: clHtmDarkGoldenrod; Name: 'clHtmDarkGoldenrod'),
    (Value: clHtmKhaki; Name: 'clHtmKhaki'),
    (Value: clHtmKhaki3; Name: 'clHtmKhaki3'),
    (Value: clHtmKhaki4; Name: 'clHtmKhaki4'),
    (Value: clHtmDarkGoldenrod1; Name: 'clHtmDarkGoldenrod1'),
    (Value: clHtmDarkGoldenrod2; Name: 'clHtmDarkGoldenrod2'),
    (Value: clHtmDarkGoldenrod3; Name: 'clHtmDarkGoldenrod3'),
    (Value: clHtmSienna1; Name: 'clHtmSienna1'),
    (Value: clHtmSienna2; Name: 'clHtmSienna2'),
    (Value: clHtmDarkOrange; Name: 'clHtmDarkOrange'),
    (Value: clHtmDarkOrange1; Name: 'clHtmDarkOrange1'),
    (Value: clHtmDarkOrange2; Name: 'clHtmDarkOrange2'),
    (Value: clHtmDarkOrange3; Name: 'clHtmDarkOrange3'),
    (Value: clHtmSienna3; Name: 'clHtmSienna3'),
    (Value: clHtmSienna; Name: 'clHtmSienna'),
    (Value: clHtmSienna4; Name: 'clHtmSienna4'),
    (Value: clHtmIndianRed4; Name: 'clHtmIndianRed4'),
    (Value: clHtmDarkOrange4; Name: 'clHtmDarkOrange4'),
    (Value: clHtmSalmon4; Name: 'clHtmSalmon4'),
    (Value: clHtmDarkGoldenrod4; Name: 'clHtmDarkGoldenrod4'),
    (Value: clHtmGold4; Name: 'clHtmGold4'),
    (Value: clHtmGoldenrod4; Name: 'clHtmGoldenrod4'),
    (Value: clHtmLightSalmon4; Name: 'clHtmLightSalmon4'),
    (Value: clHtmChocolate; Name: 'clHtmChocolate'),
    (Value: clHtmCoral3; Name: 'clHtmCoral3'),
    (Value: clHtmCoral2; Name: 'clHtmCoral2'),
    (Value: clHtmCoral; Name: 'clHtmCoral'),
    (Value: clHtmDarkSalmon; Name: 'clHtmDarkSalmon'),
    (Value: clHtmSalmon1; Name: 'clHtmSalmon1'),
    (Value: clHtmSalmon2; Name: 'clHtmSalmon2'),
    (Value: clHtmSalmon3; Name: 'clHtmSalmon3'),
    (Value: clHtmLightSalmon3; Name: 'clHtmLightSalmon3'),
    (Value: clHtmLightSalmon2; Name: 'clHtmLightSalmon2'),
    (Value: clHtmLightSalmon; Name: 'clHtmLightSalmon'),
    (Value: clHtmSandyBrown; Name: 'clHtmSandyBrown'),
    (Value: clHtmHotPink; Name: 'clHtmHotPink'),
    (Value: clHtmHotPink1; Name: 'clHtmHotPink1'),
    (Value: clHtmHotPink2; Name: 'clHtmHotPink2'),
    (Value: clHtmHotPink3; Name: 'clHtmHotPink3'),
    (Value: clHtmHotPink4; Name: 'clHtmHotPink4'),
    (Value: clHtmLightCoral; Name: 'clHtmLightCoral'),
    (Value: clHtmIndianRed1; Name: 'clHtmIndianRed1'),
    (Value: clHtmIndianRed2; Name: 'clHtmIndianRed2'),
    (Value: clHtmIndianRed3; Name: 'clHtmIndianRed3'),
    (Value: clHtmRed; Name: 'clHtmRed'),
    (Value: clHtmRed1; Name: 'clHtmRed1'),
    (Value: clHtmRed2; Name: 'clHtmRed2'),
    (Value: clHtmFirebrick1; Name: 'clHtmFirebrick1'),
    (Value: clHtmFirebrick2; Name: 'clHtmFirebrick2'),
    (Value: clHtmFirebrick3; Name: 'clHtmFirebrick3'),
    (Value: clHtmPink; Name: 'clHtmPink'),
    (Value: clHtmRosyBrown1; Name: 'clHtmRosyBrown1'),
    (Value: clHtmRosyBrown2; Name: 'clHtmRosyBrown2'),
    (Value: clHtmPink2; Name: 'clHtmPink2'),
    (Value: clHtmLightPink; Name: 'clHtmLightPink'),
    (Value: clHtmLightPink1; Name: 'clHtmLightPink1'),
    (Value: clHtmLightPink2; Name: 'clHtmLightPink2'),
    (Value: clHtmPink3; Name: 'clHtmPink3'),
    (Value: clHtmRosyBrown3; Name: 'clHtmRosyBrown3'),
    (Value: clHtmRosyBrown; Name: 'clHtmRosyBrown'),
    (Value: clHtmLightPink3; Name: 'clHtmLightPink3'),
    (Value: clHtmRosyBrown4; Name: 'clHtmRosyBrown4'),
    (Value: clHtmLightPink4; Name: 'clHtmLightPink4'),
    (Value: clHtmPink4; Name: 'clHtmPink4'),
    (Value: clHtmLavenderBlush4; Name: 'clHtmLavenderBlush4'),
    (Value: clHtmLightGoldenrod4; Name: 'clHtmLightGoldenrod4'),
    (Value: clHtmLemonChiffon4; Name: 'clHtmLemonChiffon4'),
    (Value: clHtmLemonChiffon3; Name: 'clHtmLemonChiffon3'),
    (Value: clHtmLightGoldenrod3; Name: 'clHtmLightGoldenrod3'),
    (Value: clHtmLightGolden2; Name: 'clHtmLightGolden2'),
    (Value: clHtmLightGoldenrod; Name: 'clHtmLightGoldenrod'),
    (Value: clHtmLightGoldenrod1; Name: 'clHtmLightGoldenrod1'),
    (Value: clHtmLemonChiffon2; Name: 'clHtmLemonChiffon2'),
    (Value: clHtmLemonChiffon; Name: 'clHtmLemonChiffon'),
    (Value: clHtmLightGoldenrodYellow; Name: 'clHtmLightGoldenrodYellow')
    {$ENDIF}
    );

function RxColorToString(Color: TColor): string;
var
  I: Integer;
begin
  if not ColorToIdent(Color, Result) then
  begin
    for I := Low(Colors) to High(Colors) do
      if Colors[I].Value = Color then
      begin
        Result := Colors[I].Name;
        Exit;
      end;
    Result := Format('$%.8x', [Color]);
  end;
end;

function RxIdentToColor(const Ident: string; var Color: TColor): Boolean;
var
  I: Integer;
begin
  {own colors}
  for I := Low(Colors) to High(Colors) do
    if AnsiCompareText(Colors[I].Name, Ident) = 0 then
    begin
      Color := Colors[I].Value;
      Result := True;
      Exit;
    end;
  {systems colors}
  Result := IdentToColor(Ident, Integer(Color));
end;

function RxStringToColor(S: string): TColor;
begin
  if not RxIdentToColor(S, Result) then
  try
    Result := StringToColor(S);
  except
    Result := clNone;
  end;
end;

procedure RxGetColorValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  GetColorValues(Proc);
  for I := Low(Colors) to High(Colors) do
    Proc(StrPas(Colors[I].Name));
end;

end.