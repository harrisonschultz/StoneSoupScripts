# StoneSoupScripts
Various scripts for Dungeon Crawl Stone Soup

These scripts can be added to your rc file for Dungeon Crawl Stone Soup. They must be invoked manually during gameplay using macros. After adding a script to your rc file you must then create a macro to invoke it. Use at your own risk. If your character dies because of this script don't blame me.

* Identify Scrolls and Potions
This will automatically identify all scrolls and potions in the recommended way to do so. It works is as follows. (Keep in mind the script can only know what your character knows. So if you have not yet "identified" the scroll of identify then when you run the script you will have to manually choose something to identify. After your character knows the identify scroll this will happen automatically.)
    - Potions are identified first unless you have no "scrolls of identify" (or have not discovered which scroll that is).
    - Scrolls are NEVER identified with "scroll of identify". The script will ALWAYS use the scroll.
    - IDENTIFIED scrolls and potions are NEVER used unless its a "scroll of identify".
    - All scrolls/potions are used/identified in descending order starting with your highest quantity stack. 
    - Unidentified potions will never be used automatically. Only unidentifed scrolls.
