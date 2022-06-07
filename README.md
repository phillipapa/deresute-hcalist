## deresute-hcalist
**VERSION 07062022**

A tool to list all new songs from deresute that you haven't downloaded/extracted before   
**Required file or directory:**
- **empty hcadb.txt**
- **dumped hca files inside "/deresute_hca" folder or directory**
  
---
*NOTES:*
- There is a simple instruction in the bat file itself, though if you still don't understand, you can read this one instead  
- If you aren't doing any extraction then there's no need for all these stuff, it's only intended to help those who wants to extract the songs themselves.  
- Only works in windows since it's a batch file  
- Might need admin permissions if used within `C:/` directory or the like
  
  
**How to use the bat file:**
1. Extract all the stuff in any folder as you like (if it's archived/zipped), although it's not recommended to extract it to important/admin-required directory like `C:\`
2. Place your previously extracted hca files in the empty folder provided (if you deleted the hca files though, this won't work unfortunately)
3. Open up your manifest file with the db browser and filter on the name column with "l/" (without quotes) and block the name column from top to bottom
   Here's the image if you are stuck: [Image](https://i.imgur.com/xvUCD5n.jpg)
4. Copy and paste it to the empty hcadb text file provided and save
5. You're done. Just run the bat file and it will automatically create a hcadiff text file. You can check it from there or look at the cmd panel.
   Example of how it works: [Image](https://i.imgur.com/Ku1l5cj.png)
6. Any files that are non-standard will be excluded by default. Like those with underscores after their song number, for example: `song_1234_xxxx_yyyy.hca` and so on. You can also define your own exclusion by editing the script on the "default_exclusions" variable.
     
