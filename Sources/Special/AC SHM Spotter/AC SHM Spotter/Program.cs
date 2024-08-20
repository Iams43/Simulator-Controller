﻿using System;
using System.Globalization;
using System.Threading;

namespace ACSHMSpotter {
    static class Program {
        [STAThread]
        static void Main(string[] args) {
            Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture("en-US");

            SHMSpotter spotter = new SHMSpotter();

            if (args.Length > 0 && args[0] == "-Trigger")
            {
                spotter.initializeTrigger(args);

                spotter.Run(false, true, false);
            }
            else if (args.Length > 0 && args[0] == "-Calibrate")
            {
                spotter.initializeAnalyzer(true, args);

                spotter.Run(false, false, true);
            }
            else if (args.Length > 0 && args[0] == "-Analyze")
            {
                spotter.initializeAnalyzer(false, args);

                spotter.Run(false, false, true);
            }
            else if (args.Length > 0 && args[0] == "-Map")
            {
                if (args.Length > 1)
                    spotter.initializeMapper(args[1]);

                spotter.Run(true, false, false);
            }
            else
            {
                spotter.initializeSpotter(args);

                spotter.Run(false, false, false);
            }
        }
    }
}
