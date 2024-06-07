0. Create, on a path of choice on your computer (`<root_path>`), a directory
   `<code_path>` that will hold the code. The suggested name for this directory 
   is `abTab/`. 

1. Clone the following repositories into the `<code_path>` directory:
   - https://github.com/reinierdevalk/formats/
   - https://github.com/reinierdevalk/machine_learning/
   - https://github.com/reinierdevalk/melody_models/
   - https://github.com/reinierdevalk/representations/
   - https://github.com/reinierdevalk/tabmapper/
   - https://github.com/reinierdevalk/utils/
   - https://github.com/reinierdevalk/voice_separation/

2. cd into the `<code_path>` directory
   $ cd <code_path>
  
3. Open config.cfg and
   - replace the default value of the ROOT_PATH variable with `<root_path>`.
   - replace the default value of the CODE_PATH variable with `<code_path>`. 
   - replace the default value of the PATH_PATH variable with a directory
     that is on the `$PATH` variable. Recommended is `/usr/local/bin/`.
     
     You can check which directories are on the `$PATH` variable as follows 
     $ echo $PATH

4. Install `abTab` on your computer by running the install.sh script: 
   $ bash install.sh

5. Run `abTab`. This can be done from any directory on your computer.
   `abTab` takes ...


 

 
5. When running TabMapper for the first time, the folder tabmapper/data/ and 
   its subfolders are created. Any of the folders in this folder structure are 
   recreated whenever they have been deleted and TabMapper is run again. 
   tabmapper/data/in/tab/	holds the tablature input files
   tabmapper/data/in/MIDI/	holds the MIDI input files (vocal models)
   tabmapper/data/out/		holds the output files


boolean

path to code = 	code_path/				F:/research/software/code/eclipse/
contains	code_path/tabmapper
		code_path/utils
		code_path/format-representations

path to data = 	data_path/
contains	data_path/in/tab/
		data_path/in/MIDI/
		data_path/out/ 




java -cp '.;../../utils/bin;../../utils/lib/*;../../formats-representations/bin;../../formats-representations/lib/*' tabmapper.TabMapper

does the same as

java -cp $(for p in ../../* ; do echo -n $p"/bin"";"$p"/lib/*"";" ; done) tabmapper.TabMapper

this works from any folder

java -cp $(for p in F:/research/software/code/eclipse/* ; do echo -n $p"/bin"";"$p"/lib/*"";" ; done) tabmapper.TabMapper

i.e., 

java -cp $(for p in <code_path>* ; do echo -n $p"/bin"";"$p"/lib/*"";" ; done) tabmapper.TabMapper

java -cp '.;F:/research/software/code/eclipse/utils/bin;F:/research/software/code/eclipse/utils/lib/*;F:/research/software/code/eclipse/formats-representations/bin;F:/research/software/code/eclipse/lib/*;F:/research/software/code/eclipse/tabmapper/bin' tabmapper.TabMapper



============

java -cp $(for p in F:/research/software/code/eclipse/* ; do echo -n $p"/bin"";"$p"/lib/*"";" ; done) ui.UI N-bwd-thesis-int-4vv . '' '' user/in/4465_33-34_memor_esto-2.tbp '-k=-2|-m=0'
java -cp $(for p in ../../* ; do echo -n $p"/bin"";"$p"/lib/*"";" ; done) ui.UI N-bwd-thesis-int-4vv . '' '' user/in/4465_33-34_memor_esto-2.tbp '-k=-2|-m=0'