import sys
import component_name_class
import shutil
import urllib.request
import zipfile
from zipfile import BadZipFile
import tarfile
from tarfile import ExtractError


def query_yes_no(question, default="yes"):
    """Ask a yes/no question via raw_input() and return their answer.

    "question" is a string that is presented to the user.
    "default" is the presumed answer if the user just hits <Enter>.
        It must be "yes" (the default), "no" or None (meaning
        an answer is required of the user).

    The "answer" return value is True for "yes" or False for "no".
    """
    valid = {"yes": True, "y": True, "ye": True,
             "no": False, "n": False}
    if default is None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [Y/n] "
    elif default == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            sys.stdout.write("Please respond with 'yes' or 'no' "
                             "(or 'y' or 'n').\n")

def component_name_function():
    var1 = component_name_class.component_name()
    var1.x =component_name = input("Enter the Component name: ")
    print("Debugging functions_script:    ",var1.x)
    print ('The component name is ',component_name)
    return str(var1.x)

def component_version_function():
    var2 = component_name_class.component_version()
    var2.x = component_version = input("Enter the component version: ")
    print("The component version is ", component_version)
    return str(var2.x)

def url_function():
    url_name = input("Enter the download URL: ")
    print ('The url entered is : ',url_name)
    url_yes_no = query_yes_no("Is this correct? ")
    if (url_yes_no == True):
        return url_name
    else:
        url_function()


def urlrequest(url,download_folder_name):

    split_url_name = url.split("/")
    tmp_var_url = split_url_name[split_url_name.__len__() - 1]
    filename_url_path = download_folder_name + "/download/src/" + tmp_var_url
    extract_folder_path = download_folder_name + "/cp/src/"
    index_of_dot = tmp_var_url.index('.')
    extension_name = tmp_var_url[index_of_dot:]
    print("Extension detected is : ", extension_name)
    urllib.request.urlretrieve(url, filename_url_path)
    extract_function(folder_where_compressed_file_is_located=filename_url_path,filename_with_extension=tmp_var_url,folder_name=extract_folder_path)


def extract_function(folder_where_compressed_file_is_located,filename_with_extension,folder_name):

    if (str(filename_with_extension).__contains__(".zip")):
        try:
            zfile = zipfile.ZipFile(folder_where_compressed_file_is_located)
            zfile.extractall(folder_name)
            print("Successfully extracted zip file")
        except BadZipFile as e:
            raise e
        zfile.close()

    if (str(filename_with_extension).__contains__(".tar.gz") or str(filename_with_extension).__contains__(".gz")
            or str(filename_with_extension).__contains__(".tar") or str(filename_with_extension).__contains__(".tgz")):
        try:
            tar = tarfile.open(folder_where_compressed_file_is_located)
            tar.extractall(folder_name)
        except tarfile.ReadError as e:
            raise e
        tar.close()