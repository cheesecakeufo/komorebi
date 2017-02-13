//
//  Copyright (C) 2015-2017 Abraham Masri <imasrim114@gmail.com>
//
//  This program is free software: you can redistribute it and/or modify it 
//  under the terms of the GNU Lesser General Public License version 3, as published    
//  by the Free Software Foundation.
//  
//  This program is distributed in the hope that it will be useful, but 
//  WITHOUT ANY WARRANTY; without even the implied warranties of    
//  MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR  
//  PURPOSE.  See the GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License along 
//  with this program.  If not, see <http://www.gnu.org/licenses/>  

using Gtk;
using Cairo;

namespace Komorebi.OnScreen {

    public class InfoBox: Box {

        // Labels box
        Gtk.Box mainContainer = new Box(Orientation.HORIZONTAL, 5);

        // RAM Image and label
        Gtk.Box ramContainer = new Box(Orientation.VERTICAL, 2);
        Gtk.Image ramImage = new Image();
        Gtk.Label ramLabel = new Label("1.5/4.0GB");

        // CPU Image and label
        Gtk.Box cpuContainer = new Box(Orientation.VERTICAL, 2);
        Gtk.Image cpuImage = new Image();
        Gtk.Label cpuLabel = new Label("54.4%");

        // CPU usage info
        long totalCPU = 0;
        long idleCPU = 0;

        // Time updater
        public uint timeout;

        // Color mode (dark/light)
        bool darkMode = false;

        public InfoBox () {

            orientation = Orientation.HORIZONTAL;
            spacing = 50;
            margin = 30;
            margin_top = 50;

            // Add widgets
            ramContainer.add(ramImage);
            ramContainer.add(ramLabel);

            cpuContainer.add(cpuImage);
            cpuContainer.add(cpuLabel);

            add(ramContainer);
            add(cpuContainer);
        }


        public void initInfoWidgets (bool darkMode) {

            this.darkMode = darkMode;
            var mode = "light";

            if(darkMode)
                mode = "dark";

            // Images first
            ramImage.set_from_file(@"/System/Resources/Komorebi/ram_$mode.svg");

            if(getCPUArch() == 32)
        	   cpuImage.set_from_file(@"/System/Resources/Komorebi/cpu_32_$mode.svg");
            else
               cpuImage.set_from_file(@"/System/Resources/Komorebi/cpu_64_$mode.svg");

            updateInfo();

            timeout = Timeout.add(2000, updateInfo);

        }

        bool updateInfo () {

            var color = "white";

            if(darkMode)
                color = "black";

            try {
    			// Memory (RAM)
    			GTop.Mem mem;
    			GTop.get_mem (out mem);
                    
    			var totalMemory = (float) (mem.total / 1024 / 1024) / 1000;
    			var usedMemory = (float) (mem.used  / 1024/ 1024) / 1000;

    			ramLabel.set_markup(@"<span color='%s' font='Lato Regular 10'>%.2f/%.2fGB</span>".printf(color, usedMemory, totalMemory));
                    
    			// CPU
    			GTop.Cpu cpu;
    			GTop.get_cpu (out cpu);


    			var newTotalCPU = cpu.total;
    			var newIdleCPU = cpu.idle;

    			var totalCPUDiff = (totalCPU - (long)cpu.total).abs();
    			var idleCPUDiff  = (idleCPU  - (long)cpu.idle).abs();

    			var percentage = cpu.frequency - (idleCPUDiff * 100 / totalCPUDiff);

    			totalCPU = (long)newTotalCPU;
    			idleCPU = (long)newIdleCPU;

    			cpuLabel.set_markup(@"<span color='%s' font='Lato Regular 10'>%.f%</span>".printf(color, percentage));

            } catch (Error e) {
                print(e.message);
            }

			return true;
        }

        /* TAKEN FROM ACIS --- Until Acis is public */
        /* Get CPU arch */
        public int getCPUArch () {

            string Content;
            FileUtils.get_contents("/proc/cpuinfo", out Content);

            if("lm" in Content)
                return 64;
            else
                return 32;


        }

    }
}