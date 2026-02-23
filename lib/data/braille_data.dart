
import '../models/barille_item.dart';

final List<BrailleItem> indicatorsData = const [
  BrailleItem(
    name: "Number Indicator",
    symbol: "",
    dots: [[3, 4, 5, 6]],
    audioDescription: "Number indicator, Braille dots 3 4 5 6",
  ),
  BrailleItem(
    name: "Capital Indicator",
    symbol: "",
    dots: [[6]],
    audioDescription: "Capital indicator, Braille dot 6",
  ),
  BrailleItem(
    name: "letter Indicator",
    symbol: "",
    dots: [[5, 6]],
    audioDescription: "letter indicator, Braille dots 5 6",
  ),

];

final List<BrailleItem> numbersData = [
  const BrailleItem(name: "Number 0", symbol: "0", dots: [[3, 4, 5, 6], [3,5,6]], audioDescription: "Number 0,Number indicator 3 4 5 6 Braille dots 3 5 6"), // Using standard dots
  const BrailleItem(name: "Number 1", symbol: "1", dots: [[3, 4, 5, 6], [2]], audioDescription: "Number 1, Number indicator 3 4 5 6 Braille dot 2"),
  const BrailleItem(name: "Number 2", symbol: "2", dots: [[3, 4, 5, 6], [2, 3]], audioDescription: "Number 2, Number indicator 3 4 5 6 Braille dots 2 3"),
  const BrailleItem(name: "Number 3", symbol: "3", dots: [[3, 4, 5, 6], [2, 5]], audioDescription: "Number 3, Numebr indicator 3 4 5 6 Braille dots 2 5"),
  const BrailleItem(name: "Number 4", symbol: "4", dots: [[3, 4, 5, 6], [2,5, 6]], audioDescription: "Number 4, Number indicator 3 4 5 6 Braille dots 2 5 6"),
  const BrailleItem(name: "Number 5", symbol: "5", dots: [[3, 4, 5, 6], [2, 6]], audioDescription: "Number 5, Number indicator 3 4 5 6 Braille dots 2 6"),
  const BrailleItem(name: "Number 6", symbol: "6", dots: [[3, 4, 5, 6], [2, 3, 5]], audioDescription: "Number 6, Number indicator 3 4 5 6 Braille dots 2 3 5"),
  const BrailleItem(name: "Number 7", symbol: "7", dots: [[3, 4, 5, 6], [2, 3, 5, 6]], audioDescription: "Number 7, Number indicator 3 4 5 6 Braille dots 2 3 5 6"),
  const BrailleItem(name: "Number 8", symbol: "8", dots: [[3, 4, 5, 6], [2, 3, 6]], audioDescription: "Number 8, Number indicator 3 4 5 6 Braille dots 2 3 6"),
  const BrailleItem(name: "Number 9", symbol: "9", dots: [[3, 4, 5, 6], [3, 5]], audioDescription: "Number 9, Number indicator 3 4 5 6 Braille dots 3 5"),
];

final List<BrailleItem> basicOpsData = [
  const BrailleItem(name: "Plus Sign", symbol: "+", dots: [[3, 4, 6]],
      audioDescription: "Plus Sign, Braille dots 3 4 6"),
  const BrailleItem(name: "Minus Sign", symbol: "-", dots: [[3, 6]],
      audioDescription: "Minus Sign, Braille dots 3 6"),
  const BrailleItem(name: "Multiplication Sign (Dot product)", symbol: ".", dots: [[1, 6]],
      audioDescription: "Multiplication Sign (Dot product), Braille dots 1 6"),
  const BrailleItem(name: "Multiplication Sign (Cross product)", symbol: "X", dots: [[4],[1, 6]],
      audioDescription: "Multiplication Sign (Cross product), Braille dots 4 and 1 6"),
  const BrailleItem(name: "Division Sign", symbol: "/", dots: [[4, 6],[3, 4]],
      audioDescription: "Division Sign, Braille dots 4 6 and 3 4"),

  // --- Add the remaining operations ---

  const BrailleItem(name: "Equals Sign", symbol: "=", dots: [[4,6],[1,3]],
      audioDescription: "Equals sign, Braille dots 4 6 and 1 3"),

  const BrailleItem(name: "Not Equal To", symbol: "≠", dots: [[3,4],[4,6],[1,3]],
      audioDescription: "Not equal to, Braille dots 3 4 and 4 6 then 1 3"),

  const BrailleItem(name: "Greater Than", symbol: ">", dots: [[4,6],[2]],
      audioDescription: "Greater than, Braille dots 4 6 and 2"),

  const BrailleItem(name: "Less Than", symbol: "<", dots: [[5],[1,3]],
      audioDescription: "Less than, Braille dots 5 and 1 3"),

  const BrailleItem(name: "Greater than or Equal to", symbol: "≥",
      dots: [[4,6],[2],[1,5,6,]],
      audioDescription: "Greater than or equal to, Braille dots 4 6 and 2 and 1 5 6"),

  const BrailleItem(name: "Less than or Equal to", symbol: "≤",
      dots: [[5],[1,3],[1,5,6]],
      audioDescription: "Less than or equal to, Braille dots 5 and 1 3 and 1 5 6"),

  const BrailleItem(name: "Percent Sign", symbol: "%", dots: [[4],[3,5,6]],
      audioDescription: "Percent sign, Braille dots 4 and 3 5 6"),

  const BrailleItem(name: "Decimal Point", symbol: ".", dots: [[4,6]],
      audioDescription: "Decimal point, Braille dots 4 6"),

  const BrailleItem(name: "Exponent / Power (Caret)", symbol: "^",
      dots: [[4,5]],
      audioDescription: "Exponent caret symbol, Braille dots 4 5"),

  const BrailleItem(name: "Subscript Indicator",
    symbol: "",
    dots: [[5, 6]],
    audioDescription: "Subscript indicator, Braille dot 5 6",
  ),

  const BrailleItem(name: "Proportional To", symbol: "∝",
      dots: [[6],[1,2,3,4,5,6]],
      audioDescription: "Proportional to, Braille dots 6 and 1 2 3 4 5 6"),

   // Summation
  const BrailleItem(
    name: "Summation",
    symbol: "∑",
    dots: [[2, 3, 4]],
    audioDescription: "Summation, Braille dots 2 3 4",
  ),

];


final List<BrailleItem> specialSymbolsData = [
  const BrailleItem(name: "Hyphen", symbol: "-", dots: [[3, 6]], audioDescription: "Hyphen, Braille dots 3 6"),
  const BrailleItem(name: "Short Dash (en dash)", symbol: "–", dots: [[3, 6],[3, 6]], audioDescription: "Short Dash, Braille dots 3 6 and 3 6"), // Example: two hyphens
  const BrailleItem(name: "Long Dash (em dash)", symbol: "—", dots: [[3, 6],[3, 6],[3, 6]], audioDescription: "Long Dash, Braille dots 3 6 and 3 6 and 3 6"), // Example: three hyphens
  const BrailleItem(name: "Mathematical Comma", symbol: ",", dots: [[6]], audioDescription: "Mathematical Comma, Braille dot 6"), // Differs from literary comma (dot 2)
  const BrailleItem(name: "Ellipsis", symbol: "...", dots: [[2, 5, 6],[2, 5, 6],[2, 5, 6]], audioDescription: "Ellipsis, Braille dots 2 5 6, repeated three times"), // Period is 2,5,6
  const BrailleItem(name: "Shape Indicator (Nemeth)", symbol: "", dots: [[1, 2, 4, 6]], audioDescription: "Shape Indicator, Braille dots 1 2 4 6"), // Usually placed before and after canceled material
];

final List<BrailleItem> bracketsData = const [

  // Parentheses
  BrailleItem(
    name: "Opening Parenthesis",
    symbol: "(",
    dots: [[1, 2, 3, 5, 6]],
    audioDescription: "Opening parenthesis, Braille dots 1 2 3 5 6",
  ),

  BrailleItem(
    name: "Closing Parenthesis",
    symbol: ")",
    dots: [[2, 3, 4, 5, 6]],
    audioDescription: "Closing parenthesis, Braille dots 2 3 4 5 6",
  ),

  // Square Brackets
  BrailleItem(
    name: "Opening Square Bracket",
    symbol: "[",
    dots: [[4],[1, 2, 3, 5, 6]],
    audioDescription: "Opening square bracket, Braille dots 4 and 1 2 3 5 6",
  ),

  BrailleItem(
    name: "Closing Square Bracket",
    symbol: "]",
    dots: [[4],[2, 3, 4, 5, 6]],
    audioDescription: "Closing square bracket, Braille dots 4 and 2 3 4 5 6",
  ),

  // Curly Braces
  BrailleItem(
    name: "Opening Curly Brace",
    symbol: "{",
    dots: [[4, 6],[1, 2, 3, 5, 6]],
    audioDescription: "Opening curly brace, Braille dots 4 and 1 2 3 5 6",
  ),

  BrailleItem(
    name: "Closing Curly Brace",
    symbol: "}",
    dots: [[4, 6],[2, 3, 4, 5, 6]],
    audioDescription: "Closing curly brace, Braille dots 4 and 2 3 4 5 6",
  ),

  // Absolute Value
  BrailleItem(
    name: "Absolute Value Bar",
    symbol: "|",
    dots: [[1, 2, 5, 6]],
    audioDescription: "Absolute value bar, Braille dots 1 2 5 6",
  ),

  // Angle Brackets
  BrailleItem(
    name: "Opening Angle Bracket",
    symbol: "⟨",
    dots: [[1, 2, 6]],
    audioDescription: "Opening angle bracket, Braille dots 1 2 6",
  ),

  BrailleItem(
    name: "Closing Angle Bracket",
    symbol: "⟩",
    dots: [[3, 4, 5]],
    audioDescription: "Closing angle bracket, Braille dots 3 4 5",
  ),

  // Mathematical Operators Often Grouped Here
  BrailleItem(
    name: "Integral Sign (Nemeth)",
    symbol: "∫",
    dots: [[1, 3, 4, 6]],
    audioDescription: "Integral sign, Braille dots 1 3 4 6",
  ),

  BrailleItem(
    name: "Radical Sign / Square Root",
    symbol: "√",
    dots: [[3, 4, 5]],
    audioDescription: "Radical sign, Braille dots 3 4 5",
  ),

  BrailleItem(
    name: "Closing Radical",
    symbol: "",
    dots: [[1, 2, 4, 5, 6]],
    audioDescription: "Closing radical, Braille dots 1 2 4 5 6",
  ),
];


final List<BrailleItem> greekLettersData = const [

  // Indicator
  BrailleItem(
    name: "Greek Letter Indicator",
    symbol: "",
    dots: [[4, 6]],
    audioDescription: "Greek letter indicator, Braille dots 4 6",
  ),

  // Lowercase Greek Letters
  BrailleItem(
    name: "Alpha",
    symbol: "α",
    dots: [[4, 6], [1]],
    audioDescription: "Alpha, Braille dot 1",
  ),

  BrailleItem(
    name: "Beta",
    symbol: "β",
    dots: [[4, 6], [1, 2]],
    audioDescription: "Beta, Braille dots 1 2",
  ),

  BrailleItem(
    name: "Gamma",
    symbol: "γ",
    dots: [[4, 6], [1, 2, 4, 5]],
    audioDescription: "Gamma, Braille dots 1 2 4 5",
  ),

  BrailleItem(
    name: "Delta",
    symbol: "δ",
    dots: [[4, 6], [1, 4, 5]],
    audioDescription: "Delta, Braille dots 1 4 5",
  ),

  BrailleItem(
    name: "Epsilon",
    symbol: "ε",
    dots: [[4, 6], [1, 5]],
    audioDescription: "Epsilon, Braille dots 1 5",
  ),

  BrailleItem(
    name: "Theta",
    symbol: "θ",
    dots: [[4, 6], [1, 4, 5, 6]],
    audioDescription: "Theta, Braille dots 1 4 5 6",
  ),

  BrailleItem(
    name: "Lambda",
    symbol: "λ",
    dots: [[4, 6], [1, 2, 3]],
    audioDescription: "Lambda, Braille dots 1 2 3",
  ),

  BrailleItem(
    name: "Mu",
    symbol: "μ",
    dots: [[4, 6], [1, 3, 4]],
    audioDescription: "Mu, Braille dots 1 3 4",
  ),

  BrailleItem(
    name: "Pi",
    symbol: "π",
    dots: [[4, 6], [1, 2, 3, 4]],
    audioDescription: "Pi, Braille dots 1 2 3 4",
  ),

  BrailleItem(
    name: "rho",
    symbol: "ρ",
    dots: [[4, 6], [1, 2, 3, 5]],
    audioDescription: "rho, Braille dots 1 2 3 5",
  ),

    BrailleItem(
    name: "nu",
    symbol: "ν",
    dots: [[4, 6], [1, 3, 4, 5]],
    audioDescription: "nu, Braille dots 1 3 4 5",
  ),

  BrailleItem(
    name: "Sigma",
    symbol: "σ",
    dots: [[4, 6], [2, 3, 4]],
    audioDescription: "Sigma, Braille dots 2 3 4",
  ),

  BrailleItem(
    name: "Phi",
    symbol: "φ",
    dots: [[4, 6], [1, 2, 4]],
    audioDescription: "Phi, Braille dots 1 2 4",
  ),

  BrailleItem(
    name: "Omega",
    symbol: "ω",
    dots: [[4, 6], [2, 4, 5, 6]],
    audioDescription: "Omega, Braille dots 2 4 5 6",
  ),
];


final List<BrailleItem> allBrailleItems = [
  ...indicatorsData,
  ...numbersData,
  ...basicOpsData,
  ...specialSymbolsData,
  ...bracketsData,
  ...greekLettersData,
  ...fractionsPowersData,
  ...advancedMathData,
  ...algebraData,
  ...geometryUnitsData,
  ...scienceSymbolsData,
  ...scienceSymbolsData,
  ...scientificIndicatorsData,
  ...scientificUnitsData,
  ...physicsSymbolsData,
  ...chemistryElementsData,
  ...biologySymbolsData,
];


List<BrailleItem> getBrailleDataList(String title) {
  switch (title) {
    case 'Indicators': return indicatorsData;
    case 'Numbers': return numbersData;
    case 'Basic Operations': return basicOpsData;
    case 'Special Symbols': return specialSymbolsData;
    case 'Brackets': return bracketsData;
    case 'Greek Letters': return greekLettersData;
    case 'Fractions & Powers': return fractionsPowersData;
    case 'Advanced Math': return advancedMathData;
    case 'Algebra': return algebraData;
    case 'Geometry & Units': return geometryUnitsData;
    case 'Science Symbols': return scienceSymbolsData;
    case 'Scientific Indicators': return scientificIndicatorsData;
    case 'Scientific Units': return scientificUnitsData;
    case 'Physics Symbols': return physicsSymbolsData;
    case 'Chemistry Symbols': return chemistryElementsData;
    case 'Biology Symbols': return biologySymbolsData;
    case 'Science Symbols': return scienceSymbolsData;

    default: return [];
  }
}


final List<BrailleItem> fractionsPowersData = const [
  BrailleItem(
    name: "Fraction Line",
    symbol: "/",
    dots: [[4, 5, 6], [3, 4]],
    audioDescription: "Fraction line, Braille dots 4 5 6 and 3 4",
  ),
  BrailleItem(
    name: "fraction open",
    symbol: "",
    dots: [[1, 4, 5, 6]],
    audioDescription: "fraction open, Braille dots 1 4 5 6",
  ),
  BrailleItem(
    name: "fraction close",
    symbol: "",
    dots: [[3, 4, 5, 6]],
    audioDescription: "fraction close, Braille dot 3 4 5 6",
  ),
  BrailleItem(
    name: "mixed fraction open",
    symbol: "",
    dots: [[4,5,6],[1, 4, 5, 6]],
    audioDescription: "mixed fraction open, Braille dots 4 5 6 and 1 4 5 6",
  ),
  BrailleItem(
    name: "mixed fraction close",
    symbol: "",
    dots: [[4,5,6],[3, 4, 5, 6]],
    audioDescription: "mixed fraction close, Braille dot 4 5 6 and 3 4 5 6",
  ),
];

final List<BrailleItem> advancedMathData = const [
  BrailleItem(
    name: "Factorial",
    symbol: "!",
    dots: [[2, 3, 5]],
    audioDescription: "Factorial, Braille dots 2 3 5",
  ),
  BrailleItem(
    name: "Plus Minus",
    symbol: "±",
    dots: [[3,4,6],[3,6]],
    audioDescription: "Plus minus, Braille dots 3 4 6 and 3 6",
  ),
];

final List<BrailleItem> algebraData = const [
  BrailleItem(
    name: "Variable x",
    symbol: "x",
    dots: [[1, 3, 4, 6]],
    audioDescription: "Variable x, Braille dots 1 3 4 6",
  ),
  BrailleItem(
    name: "Variable y",
    symbol: "y",
    dots: [[1, 3, 4, 5, 6]],
    audioDescription: "Variable y, Braille dots 1 3 4 5 6",
  ),
  BrailleItem(
    name: "Variable z",
    symbol: "z",
    dots: [[1, 3, 5, 6]],
    audioDescription: "Variable z, Braille dots 1 3 5 6",
  ),
];

final List<BrailleItem> geometryUnitsData = const [
  BrailleItem(
    name: "Shape Indicator",
    symbol: "",
    dots: [[1,2,4,6]],
    audioDescription: "Shape indicator, Braille dots 1 2 4 6",
  ),
  BrailleItem(
    name: "Angle",
    symbol: "∠",
    dots: [[2, 4, 6]],
    audioDescription: "Angle, Braille dots 2 4 6",
  ),
  BrailleItem(
    name: "Degree",
    symbol: "°",
    dots: [[1, 5]],
    audioDescription: "Degree symbol, Braille dots 1 5",
  ),
  BrailleItem(
    name: "Parallel",
    symbol: "∥",
    dots: [[1,2,3]],
    audioDescription: "Parallel, Braille dots 1 2 3",
  ),
];

final List<BrailleItem> scienceSymbolsData = const [
  BrailleItem(
    name: "Ohm",
    symbol: "Ω",
    dots: [[1, 2, 5]],
    audioDescription: "Ohm, Braille dots 1 2 5",
  ),
  BrailleItem(
    name: "Delta Change",
    symbol: "Δ",
    dots: [[1, 4, 5]],
    audioDescription: "Delta change, Braille dots 1 4 5",
  ),
];

final List<BrailleItem> scientificIndicatorsData = const [
  BrailleItem(name: "Number Sign", symbol: "#", dots: [[3, 4, 5, 6]], audioDescription: "Number sign. Braille dots 3 4 5 6"),
  BrailleItem(name: "Decimal Point", symbol: ".", dots: [[4, 6]], audioDescription: "Decimal point. Braille dots 4 6"),
  BrailleItem(name: "Capital Letter Indicator", symbol: "", dots: [[6]], audioDescription: "Capital letter indicator. Braille dot 6"),
];

final List<BrailleItem> scientificUnitsData = const [
  BrailleItem(
    name: "Meter",
    symbol: "m",
    dots: [[1, 3, 4]],
    audioDescription: "Meter. Braille dots one three four",
  ),
  BrailleItem(
    name: "Second",
    symbol: "s",
    dots: [[2, 3, 4]],
    audioDescription: "Second. Braille dots two three four",
  ),
  BrailleItem(
    name: "Kilogram",
    symbol: "kg",
    dots: [[1,3],[1,2,4,5]],
    audioDescription: "Kilogram. Braille dots 1 3 and 1 2 4 5",
  ),
  BrailleItem(
    name: "Ampere",
    symbol: "A",
    dots: [[1]],
    audioDescription: "Ampere. Braille dot one",
  ),
  BrailleItem(
    name: "Kelvin",
    symbol: "K",
    dots: [[1, 3]],
    audioDescription: "Kelvin. Braille dots one three",
  ),
  BrailleItem(
    name: "Mole",
    symbol: "mol",
    dots: [[1,3,4],[1,3,5],[1,2,3]],
    audioDescription: "Mole. Braille dots 1 3 4 and 1 3 5 and 1 2 3",
  ),
  BrailleItem(
    name: "Candela",
    symbol: "cd",
    dots: [[1, 4],[1, 4, 5]],
    audioDescription: "Candela. Braille dots 1 4 and 1 4 5",
  ),
  BrailleItem(
    name: "Hertz",
    symbol: "Hz",
    dots: [[1, 2, 5]],
    audioDescription: "Hertz. Braille dots one two five",
  ),
  BrailleItem(
    name: "Newton",
    symbol: "N",
    dots: [[1, 3, 4, 5]],
    audioDescription: "Newton. Braille dots one three four five",
  ),
  BrailleItem(
    name: "Joule",
    symbol: "J",
    dots: [[2, 4, 5]],
    audioDescription: "Joule. Braille dots two four five",
  ),
];

final List<BrailleItem> physicsSymbolsData = const [
  BrailleItem(
    name: "Velocity",
    symbol: "v",
    dots: [[1, 2, 3, 6]],
    audioDescription: "Velocity. Braille dots one two three six",
  ),
  BrailleItem(
    name: "Acceleration",
    symbol: "a",
    dots: [[1]],
    audioDescription: "Acceleration. Braille dot one",
  ),
  BrailleItem(
    name: "Force",
    symbol: "F",
    dots: [[1, 2, 4]],
    audioDescription: "Force. Braille dots one two four",
  ),
  BrailleItem(
    name: "Energy",
    symbol: "E",
    dots: [[1, 5]],
    audioDescription: "Energy. Braille dots one five",
  ),
  BrailleItem(
    name: "Power",
    symbol: "P",
    dots: [[1, 2, 3, 4]],
    audioDescription: "Power. Braille dots one two three four",
  ),
  BrailleItem(
    name: "Work",
    symbol: "W",
    dots: [[2, 4, 5, 6]],
    audioDescription: "Work. Braille dots two four five six",
  ),
  BrailleItem(
    name: "Momentum",
    symbol: "p",
    dots: [[1, 2, 3, 4]],
    audioDescription: "Momentum. Braille dots one two three four",
  ),
  BrailleItem(
    name: "Pressure",
    symbol: "P",
    dots: [[1, 2, 3, 4]],
    audioDescription: "Pressure. Braille dots one two three four",
  ),
  BrailleItem(
    name: "Frequency",
    symbol: "f",
    dots: [[1, 2, 4]],
    audioDescription: "Frequency. Braille dots one two four",
  ),
];

final List<BrailleItem> chemistryElementsData = const [
  BrailleItem(
    name: "Hydrogen",
    symbol: "H",
    dots: [[1, 2, 5]],
    audioDescription: "Hydrogen. Braille dots one two five",
  ),
  BrailleItem(
    name: "Oxygen",
    symbol: "O",
    dots: [[1, 3, 5]],
    audioDescription: "Oxygen. Braille dots one three five",
  ),
  BrailleItem(
    name: "Carbon",
    symbol: "C",
    dots: [[1, 4]],
    audioDescription: "Carbon. Braille dots one four",
  ),
  BrailleItem(
    name: "Nitrogen",
    symbol: "N",
    dots: [[1, 3, 4, 5]],
    audioDescription: "Nitrogen. Braille dots one three four five",
  ),
  BrailleItem(
    name: "Helium",
    symbol: "He",
    dots: [[1, 2, 5]],
    audioDescription: "Helium. Braille dots one two five",
  ),
  BrailleItem(
    name: "Sodium",
    symbol: "Na",
    dots: [[1, 3, 4]],
    audioDescription: "Sodium. Braille dots one three four",
  ),
  BrailleItem(
    name: "Chlorine",
    symbol: "Cl",
    dots: [[1, 4, 5]],
    audioDescription: "Chlorine. Braille dots one four five",
  ),
  BrailleItem(
    name: "Iron",
    symbol: "Fe",
    dots: [[1, 2, 4]],
    audioDescription: "Iron. Braille dots one two four",
  ),
  BrailleItem(
    name: "Copper",
    symbol: "Cu",
    dots: [[1, 4]],
    audioDescription: "Copper. Braille dots one four",
  ),
  BrailleItem(
    name: "Zinc",
    symbol: "Zn",
    dots: [[1, 3, 5, 6]],
    audioDescription: "Zinc. Braille dots one three five six",
  ),
];

final List<BrailleItem> biologySymbolsData = const [
  BrailleItem(
    name: "DNA",
    symbol: "DNA",
    dots: [[1, 4, 5],[1,3,4,5],[1]],
    audioDescription: "DNA. Braille dots 1 2 5 and 1 3 4 5 and 1",
  ),
  BrailleItem(
    name: "RNA",
    symbol: "RNA",
    dots: [[1,2,3,5],[1,3,4,5],[1]],
    audioDescription: "RNA. Braille dots 1 2 3 5 and 1 3 4 5 and 1",
  ),
  BrailleItem(
    name: "Cell",
    symbol: "Cell",
    dots: [[1, 4]],
    audioDescription: "Cell. Braille dots one four",
  ),
  BrailleItem(
    name: "Chromosome",
    symbol: "X",
    dots: [[1, 3, 4, 6]],
    audioDescription: "Chromosome. Braille dots one three six",
  ),
  BrailleItem(
    name: "Gene",
    symbol: "g",
    dots: [[1, 2, 4, 5]],
    audioDescription: "Gene. Braille dots one two four five",
  ),
  BrailleItem(
    name: "Protein",
    symbol: "P",
    dots: [[1, 2, 3, 4]],
    audioDescription: "Protein. Braille dots one two three four",
  ),
  BrailleItem(
    name: "Enzyme",
    symbol: "E",
    dots: [[1, 5]],
    audioDescription: "Enzyme. Braille dots one five",
  ),
  BrailleItem(
    name: "Mitosis",
    symbol: "M",
    dots: [[1, 3, 4]],
    audioDescription: "Mitosis. Braille dots one three four",
  ),
  BrailleItem(
    name: "Meiosis",
    symbol: "Me",
    dots: [[1, 3, 4],[1,5]],
    audioDescription: "Meiosis. Braille dots 1 3 4 and 1 5",
  ),
  BrailleItem(
    name: "Photosynthesis",
    symbol: "PS",
    dots: [[1, 2, 3, 4],[2, 3,4]],
    audioDescription: "Photosynthesis. Braille dots one two three",
  ),
];
