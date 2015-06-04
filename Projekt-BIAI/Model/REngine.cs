﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using RDotNet;
using System.Diagnostics;
using System.IO;

namespace Projekt_BIAI.Model
{
    class _REngine
    {
        /// <summary>
        /// Instancja silnika R
        /// </summary>
        private REngine engine;


        public void Initialize()
        {
            REngine.SetEnvironmentVariables();
            engine = REngine.GetInstance();
            engine.Initialize();

            // Zmienia workplace dla instancji R na wymienioną - do indywidualnych potrzeb
            engine.Evaluate("setwd(\"E:/Git/BIAI-projekt/Data\")");

        }

        /// <summary>
        /// Odpala skrypt o podanej nazwie
        /// </summary>
        public void launchScript(string scriptName)
        {
            try
            {
                if (engine != null)
                {
                    if (scriptName.Contains(".R"))
                        engine.Evaluate("source('" + scriptName + "')");
                    else
                        engine.Evaluate("source('" + scriptName + ".R')");
                }
            }
            catch (EvaluationException)
            {
                throw new EvaluationException("Brak pliku");
            }
        }

        /// <summary>
        /// Zamyka instancję. Przed zamknięciem aplikacji zawsze zamykać instancję!
        /// </summary>
        public void DisposeEngine()
        {
            if (engine != null)
                engine.Dispose();
        }
        
    }
}