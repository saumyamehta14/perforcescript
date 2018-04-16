import os
import shutil
import urllib.request
import sys
import functions_script
import component_name_class

perforceuploadpath_root = '/home/saumyamehta14/perforceupload/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot'
cwd = os.getcwd()
print ("Current working directory is ", cwd)



if (cwd != perforceuploadpath_root):
    os.chdir(perforceuploadpath_root)
    print ("Working directory changed to ", os.getcwd())   # CHangiung the directory to the folder where the upload folders should go (/home/saumyamehta14/Desktop/VMSharedFolder/perforceupload/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot)


def folder_structure_function(component_name,component_version,package_format):

    folder_name = component_name+'^'+component_version

    if (package_format == 's'):
        folder_structure = folder_name+"/cp/src/../../download/src"
    if (package_format == 'b'):
        folder_structure = folder_name + "/cp/bin/../../download/bin"

    if not os.path.exists(folder_structure):
        print ("Executing command [ mkdir -p "+folder_structure+" ]")
        os.makedirs(folder_structure)
        print("Successfully created directory")


        #file download functions
        url_name_var = functions_script.url_function()
        functions_script.urlrequest(url_name_var,folder_name)





    else:
        folderdeleteinput = functions_script.query_yes_no('Folder with same name exists. Do you want to delete that folder? ')
        if (folderdeleteinput == True):
            shutil.rmtree(folder_name)
            print ('Folder removed succesfully')

        else:
            exit()


        tmp_component_name_1 = functions_script.component_name_function()
        tmp_component_version_1 = functions_script.component_version_function()
        # print('Does your file conatins source code , binary or snippet code (Please enter s for source code and b for binary)')
        folder_structure_function(component_name = str(tmp_component_name_1),component_version = str(tmp_component_version_1),package_format='s')




tmp_component_name = functions_script.component_name_function()
tmp_component_version = functions_script.component_version_function()
print ('Does your file conatins source code , binary or snippet code (Please enter s for source code and b for binary)')
folder_structure_function(component_name = str(tmp_component_name),component_version = str(tmp_component_version), package_format='s')


