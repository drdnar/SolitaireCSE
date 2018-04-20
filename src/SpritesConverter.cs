using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpritesConverter
{
    class SpritesConverter
    {
        static void Main(string[] args)
        {
            System.Drawing.Bitmap img = new System.Drawing.Bitmap("input.png");
            StringBuilder output = new StringBuilder(65535);
            Dictionary<System.Drawing.Color, string> palette = new Dictionary<System.Drawing.Color, string>()
            {
                {System.Drawing.Color.FromArgb(0, 0, 0), "Bk"},
                {System.Drawing.Color.FromArgb(237, 28, 36), "Rd"},
                {System.Drawing.Color.FromArgb(255, 242, 0), "Yw"},
                {System.Drawing.Color.FromArgb(255, 255, 255), "Wh"}//,
                //{System.Drawing.Color.FromArgb(24, 0, 196), "Bl"}
            };
            int[,] spriteLocs = new int[,] { 
                {1, 93},
                {28, 93},
                {55, 93},
                {82, 93},
                {1, 53},
                {28, 53},
                {55, 53},
                {82, 53},
                {1, 13},
                {28, 13},
                {55, 13},
                {82, 13}
            };
            string[] spriteNames = new string[] {
                "spJackOfClubs:\r\n\t.dw\tfourColorPalette",
                "spJackOfDiamonds:\r\n\t.dw\tfourColorPalette",
                "spJackOfHearts:\r\n\t.dw\tfourColorPalette",
                "spJackOfSpades:\r\n\t.dw\tfourColorPalette",
                "spQueenOfClubs:\r\n\t.dw\tfourColorPalette",
                "spQueenOfDiamonds:\r\n\t.dw\tfourColorPalette",
                "spQueenOfHearts:\r\n\t.dw\tfourColorPalette",
                "spQueenOfSpades:\r\n\t.dw\tfourColorPalette",
                "spKingOfClubs:\r\n\t.dw\tfourColorPalette",
                "spKingOfDiamonds:\r\n\t.dw\tfourColorPalette",
                "spKingOfHearts:\r\n\t.dw\tfourColorPalette",
                "spKingOfSpades:\r\n\t.dw\tfourColorPalette"
            };
            //const int width = 24;
            const int height = 25;
            for (int spriteNumber = 0; spriteNumber < 12; spriteNumber++)
            {
                output.AppendLine(spriteNames[spriteNumber]);
                for (int y = spriteLocs[spriteNumber, 1]; y < spriteLocs[spriteNumber, 1] + height; y++)
                {
                    output.Append(" .db ");
                    int x = spriteLocs[spriteNumber, 0];
                    for (int i = 0; i < 6; i++)
                    {
                        output.Append("px(");
                        string s = palette[img.GetPixel(x++, y)];
                        if (s != null) output.Append(s); else throw new Exception("" + img.GetPixel(x, y));
                        output.Append(",");
                        s = palette[img.GetPixel(x++, y)];
                        if (s != null) output.Append(s); else throw new Exception("" + img.GetPixel(x, y));
                        output.Append(",");
                        s = palette[img.GetPixel(x++, y)];
                        if (s != null) output.Append(s); else throw new Exception("" + img.GetPixel(x, y));
                        output.Append(",");
                        s = palette[img.GetPixel(x++, y)];
                        if (s != null) output.Append(s); else throw new Exception("" + img.GetPixel(x, y));
                        output.Append(")");
                        if (i != 5)
                            output.Append(",");
                    }
                    output.AppendLine();
                }
            }
            System.IO.File.WriteAllText("output.txt", output.ToString());
        }
    }
}
