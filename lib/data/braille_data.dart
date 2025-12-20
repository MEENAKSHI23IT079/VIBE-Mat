
import '../models/barille_item.dart';

final List<BrailleItem> numbersData = [
  const BrailleItem(name: "Number 0", symbol: "0", dots: [2, 4, 5], audioDescription: "Number 0, Braille dots 2 4 5"), // Using standard dots
  const BrailleItem(name: "Number 1", symbol: "1", dots: [1], audioDescription: "Number 1, Braille dot 1"),
  const BrailleItem(name: "Number 2", symbol: "2", dots: [1, 2], audioDescription: "Number 2, Braille dots 1 2"),
  const BrailleItem(name: "Number 3", symbol: "3", dots: [1, 4], audioDescription: "Number 3, Braille dots 1 4"),
  const BrailleItem(name: "Number 4", symbol: "4", dots: [1, 4, 5], audioDescription: "Number 4, Braille dots 1 4 5"),
  const BrailleItem(name: "Number 5", symbol: "5", dots: [1, 5], audioDescription: "Number 5, Braille dots 1 5"),
  const BrailleItem(name: "Number 6", symbol: "6", dots: [1, 2, 4], audioDescription: "Number 6, Braille dots 1 2 4"),
  const BrailleItem(name: "Number 7", symbol: "7", dots: [1, 2, 4, 5], audioDescription: "Number 7, Braille dots 1 2 4 5"),
  const BrailleItem(name: "Number 8", symbol: "8", dots: [1, 2, 5], audioDescription: "Number 8, Braille dots 1 2 5"),
  const BrailleItem(name: "Number 9", symbol: "9", dots: [2, 4], audioDescription: "Number 9, Braille dots 2 4"),
];

final List<BrailleItem> basicOpsData = [
  const BrailleItem(name: "Plus Sign", symbol: "+", dots: [2, 3, 5],
      audioDescription: "Plus Sign, Braille dots 2 3 5"),
  const BrailleItem(name: "Minus Sign", symbol: "-", dots: [3, 6],
      audioDescription: "Minus Sign, Braille dots 3 6"),
  const BrailleItem(name: "Multiplication Sign", symbol: "*", dots: [1, 6],
      audioDescription: "Multiplication Sign, Braille dots 1 6"),
  const BrailleItem(name: "Division Sign", symbol: "/", dots: [3, 4],
      audioDescription: "Division Sign, Braille dots 3 4"),

  // --- Add the remaining operations ---

  const BrailleItem(name: "Equals Sign", symbol: "=", dots: [1,2,3,4,6],
      audioDescription: "Equals sign, Braille dots 1 2 3 4 6"),

  const BrailleItem(name: "Not Equal To", symbol: "≠", dots: [1,2,3,4,6, 3,4],
      audioDescription: "Not equal to, Braille dots 1 2 3 4 6 then 3 4"),

  const BrailleItem(name: "Greater Than", symbol: ">", dots: [1,5,6],
      audioDescription: "Greater than, Braille dots 1 5 6"),

  const BrailleItem(name: "Less Than", symbol: "<", dots: [1,2,6],
      audioDescription: "Less than, Braille dots 1 2 6"),

  const BrailleItem(name: "Greater or Equal", symbol: "≥",
      dots: [1,5,6, 1,2,3,4,6],
      audioDescription: "Greater or equal, Braille dots 1 5 6 then 1 2 3 4 6"),

  const BrailleItem(name: "Less or Equal", symbol: "≤",
      dots: [1,2,6, 1,2,3,4,6],
      audioDescription: "Less or equal, Braille dots 1 2 6 then 1 2 3 4 6"),

  const BrailleItem(name: "Percent Sign", symbol: "%", dots: [1,4,6],
      audioDescription: "Percent sign, Braille dots 1 4 6"),

  const BrailleItem(name: "Decimal Point", symbol: ".", dots: [4,6],
      audioDescription: "Decimal point, Braille dots 4 6"),

  const BrailleItem(name: "Exponent / Power (Caret)", symbol: "^",
      dots: [4,5],
      audioDescription: "Exponent caret symbol, Braille dots 4 5"),

  const BrailleItem(name: "Proportional To", symbol: "∝",
      dots: [1,2,3,6],
      audioDescription: "Proportional to, Braille dots 1 2 3 6"),

   // Summation
  const BrailleItem(
    name: "Summation",
    symbol: "∑",
    dots: [2, 3, 4],
    audioDescription: "Summation, Braille dots 2 3 4",
  ),

  // Pi
  const BrailleItem(
    name: "Pi",
    symbol: "π",
    dots: [1, 2, 3, 5],
    audioDescription: "Pi, Braille dots 1 2 3 5",
  ),
];


final List<BrailleItem> specialSymbolsData = [
  const BrailleItem(name: "Hyphen", symbol: "-", dots: [3, 6], audioDescription: "Hyphen, Braille dots 3 6"),
  const BrailleItem(name: "Short Dash (en dash)", symbol: "–", dots: [3, 6, 3, 6], audioDescription: "Short Dash, Braille dots 3 6, 3 6"), // Example: two hyphens
  const BrailleItem(name: "Long Dash (em dash)", symbol: "—", dots: [3, 6, 3, 6, 3, 6], audioDescription: "Long Dash, Braille dots 3 6, 3 6, 3 6"), // Example: three hyphens
  const BrailleItem(name: "Mathematical Comma", symbol: ",", dots: [6], audioDescription: "Mathematical Comma, Braille dot 6"), // Differs from literary comma (dot 2)
  const BrailleItem(name: "Ellipsis", symbol: "...", dots: [2, 5, 6, 2, 5, 6, 2, 5, 6], audioDescription: "Ellipsis, Braille dots 2 5 6, repeated three times"), // Period is 2,5,6
  const BrailleItem(name: "Cancellation Indicator (Nemeth)", symbol: "", dots: [1, 2, 4, 6], audioDescription: "Cancellation Indicator, Braille dots 1 2 4 6"), // Usually placed before and after canceled material
];

final List<BrailleItem> bracketsData = const [

  // Parentheses
  BrailleItem(
    name: "Opening Parenthesis",
    symbol: "(",
    dots: [1, 2, 3, 5, 6],
    audioDescription: "Opening parenthesis, Braille dots 1 2 3 5 6",
  ),

  BrailleItem(
    name: "Closing Parenthesis",
    symbol: ")",
    dots: [2, 3, 4, 5, 6],
    audioDescription: "Closing parenthesis, Braille dots 2 3 4 5 6",
  ),

  // Square Brackets
  BrailleItem(
    name: "Opening Square Bracket",
    symbol: "[",
    dots: [1, 2, 3, 6],
    audioDescription: "Opening square bracket, Braille dots 1 2 3 6",
  ),

  BrailleItem(
    name: "Closing Square Bracket",
    symbol: "]",
    dots: [2, 3, 5, 6],
    audioDescription: "Closing square bracket, Braille dots 2 3 5 6",
  ),

  // Curly Braces
  BrailleItem(
    name: "Opening Curly Brace",
    symbol: "{",
    dots: [1, 2, 4, 6],
    audioDescription: "Opening curly brace, Braille dots 1 2 4 6",
  ),

  BrailleItem(
    name: "Closing Curly Brace",
    symbol: "}",
    dots: [3, 4, 5, 6],
    audioDescription: "Closing curly brace, Braille dots 3 4 5 6",
  ),

  // Absolute Value
  BrailleItem(
    name: "Absolute Value Bar",
    symbol: "|",
    dots: [1, 2, 4, 5, 6],
    audioDescription: "Absolute value bar, Braille dots 1 2 4 5 6",
  ),

  // Angle Brackets
  BrailleItem(
    name: "Opening Angle Bracket",
    symbol: "⟨",
    dots: [1, 2, 6],
    audioDescription: "Opening angle bracket, Braille dots 1 2 6",
  ),

  BrailleItem(
    name: "Closing Angle Bracket",
    symbol: "⟩",
    dots: [3, 4, 5],
    audioDescription: "Closing angle bracket, Braille dots 3 4 5",
  ),

  // Mathematical Operators Often Grouped Here
  BrailleItem(
    name: "Integral Sign (Nemeth)",
    symbol: "∫",
    dots: [1, 3, 4, 6],
    audioDescription: "Integral sign, Braille dots 1 3 4 6",
  ),

  BrailleItem(
    name: "Radical Sign / Square Root",
    symbol: "√",
    dots: [1, 2, 4, 6],
    audioDescription: "Radical sign, Braille dots 1 2 4 6",
  ),

  BrailleItem(
    name: "Closing Radical",
    symbol: "",
    dots: [3, 4, 5, 6],
    audioDescription: "Closing radical, Braille dots 3 4 5 6",
  ),
];


final List<BrailleItem> greekLettersData = const [

  // Indicator
  BrailleItem(
    name: "Greek Letter Indicator",
    symbol: "",
    dots: [4, 6],
    audioDescription: "Greek letter indicator, Braille dots 4 6",
  ),

  // Lowercase Greek Letters
  BrailleItem(
    name: "Alpha",
    symbol: "α",
    dots: [1],
    audioDescription: "Alpha, Braille dot 1",
  ),

  BrailleItem(
    name: "Beta",
    symbol: "β",
    dots: [1, 2],
    audioDescription: "Beta, Braille dots 1 2",
  ),

  BrailleItem(
    name: "Gamma",
    symbol: "γ",
    dots: [1, 2, 4],
    audioDescription: "Gamma, Braille dots 1 2 4",
  ),

  BrailleItem(
    name: "Delta",
    symbol: "δ",
    dots: [1, 4, 5],
    audioDescription: "Delta, Braille dots 1 4 5",
  ),

  BrailleItem(
    name: "Epsilon",
    symbol: "ε",
    dots: [1, 5],
    audioDescription: "Epsilon, Braille dots 1 5",
  ),

  BrailleItem(
    name: "Theta",
    symbol: "θ",
    dots: [1, 4, 5, 6],
    audioDescription: "Theta, Braille dots 1 4 5 6",
  ),

  BrailleItem(
    name: "Lambda",
    symbol: "λ",
    dots: [1, 2, 3],
    audioDescription: "Lambda, Braille dots 1 2 3",
  ),

  BrailleItem(
    name: "Mu",
    symbol: "μ",
    dots: [1, 3, 4],
    audioDescription: "Mu, Braille dots 1 3 4",
  ),

  BrailleItem(
    name: "Pi",
    symbol: "π",
    dots: [1, 2, 3, 5],
    audioDescription: "Pi, Braille dots 1 2 3 5",
  ),

  BrailleItem(
    name: "Sigma",
    symbol: "σ",
    dots: [2, 3, 4],
    audioDescription: "Sigma, Braille dots 2 3 4",
  ),

  BrailleItem(
    name: "Phi",
    symbol: "φ",
    dots: [1, 2, 4, 5],
    audioDescription: "Phi, Braille dots 1 2 4 5",
  ),

  BrailleItem(
    name: "Omega",
    symbol: "ω",
    dots: [2, 4, 5],
    audioDescription: "Omega, Braille dots 2 4 5",
  ),
];


final List<BrailleItem> allBrailleItems = [
  ...numbersData,
  ...basicOpsData,
  ...specialSymbolsData,
  ...bracketsData,
  ...greekLettersData,
];

List<BrailleItem> getBrailleDataList(String title) {
  switch (title) {
    case 'Numbers (0-9)': return numbersData;
    case 'Basic Operations': return basicOpsData;
    case 'Special Symbols': return specialSymbolsData;
    case 'Brackets': return bracketsData;
    case 'Greek Letters': return greekLettersData;
    default: return [];
  }
}

