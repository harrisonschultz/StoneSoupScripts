
# StoneSoupScripts

Various scripts for Dungeon Crawl Stone Soup

  

These scripts can be added to your rc file for Dungeon Crawl Stone Soup. They must be invoked manually during gameplay using macros. After adding a script to your rc file you must then create a macro to invoke it. Use at your own risk. If your character dies because of this script don't blame me.

  
  

## Identify Scrolls and Potions

This will automatically identify all scrolls and potions in the recommended way to do so. It works is as follows. (Keep in mind the script can only know what your character knows. So if you have not yet "identified" the scroll of identify then when you run the script you will have to manually choose something to identify. After your character knows the identify scroll this will happen automatically.)

- Potions are identified first unless you have no "scrolls of identify" (or have not discovered which scroll that is).

- Scrolls are NEVER identified with "scroll of identify". The script will ALWAYS use the scroll.

- IDENTIFIED scrolls and potions are NEVER used unless its a "scroll of identify".

- All scrolls/potions are used/identified in descending order starting with your highest quantity stack.

- Unidentified potions will never be used automatically. Only unidentifed scrolls.

- All scrolls that have prompts like brand weapon will prompt you like usual. When you finish the prompt the script will continue identifying.

### To Install and Use

 1. Copy your Dungeon Crawl Stone Soup rc file and paste it into your favorite text editor (like notepad)
 2. Save it so you have a backup
 3. Copy the contents of the identify-potions-and-scrolls.lua file.
 4. In your text editor with your rc file, add curly brackets `{ }` to the bottom of the document
 5. Place your cursor within the curly brackets and paste the contents of the identify-potions-and-scrolls.lua file.
 6. Then copy your entire rc file including the new changes you just made, and paste it into your rc file wherever you Dungeon Crawl Stone Soup
 7. Lastly start or continue a dungeon crawl run, then open the edit macro screen
 8. Choose "Create/edit macro from key"
 9. Choose a key on your keyboard to invoke this script (I use the single quote key `'`)
 10. Type (you can't copy/paste) the following `===start_identify_scrolls_and_potions` and hit enter when you are finished.
 11. Close the macro screen and you are good to go. You will get messages in the log when using the script even when there is nothing to identify so you will know its working.

There is an example rc file for your reference in this repo