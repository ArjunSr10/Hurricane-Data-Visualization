#!/bin/bash

# Store arguments to script inside the following variables

arg1=$1
arg2=$2

# Following command prints out header line, and writes this to the top line of the output csv file, which is passed in as the second argument

echo "Timestamp,Latitude,Longitude,MinSeaLevelPressure,MaxIntensity" >"$arg2"




# The following line assigns, all UTC timestamps for each hurricane report in the input xml file to the variable timestampField 

# Firstly the grep command searches for patterns in the input xml file that begin with the tag <name>, followed by a UTC timestamp, and ending with the tag </name>, and the -o option is used to make sure that we find lines that contain exactly the information just mentioned and nothing extra. This is done in order to remove leading whitespaces from each line. We can extract the UTC timestamp from each of these lines. The check for this actual timestamp between the two tags is achieved through the use of regular expressions, where we first search for zero or more occurrences for numbers in the range 0 to 9 (which acts as the time of the timestamp), then for the string 'UTC', followed by zero or more occurrences for letters from A to Z (which acts as the month of the timestamp), and finally again for zero or more occurrences for numbers in the range 0 to 9 (which acts as the date of the timestamp). Therefore, all possible patterns produced from this grep command will be every line in the input xml file, that starts with the tag <name>, followed by a UTC timestamp, and ending with the tag </name>.

# Secondly, all these patterns are piped into the sed command, that removes all <name>, and </name> tags from every line, and replaces it with nothing, so we're now left with just the UTC timestamp. To remove </name> tags we use '#' as the delimiter to remove ambiguity with the '/' present in this tag.

# Finally, all the UTC timestamps are piped into the awk command, where a comma is added after every timestamp, to lead to the next field of the output csv file

timestampField=$(grep -o -e "<name>[0-9]* UTC [A-Z]* [0-9]*</name>" "$arg1" | sed -e 's/<name>//g' -e 's#</name>##g' | awk '{print $0 ","}')





# The following line assigns, all latitude and longitude values for each hurricane report obtained from the input xml file to the variable latitudeAndLongitudeField

# Firstly the first grep command uses the -A option to retrieve the next line after every line in the input kml file that contains the string 'Storm Location', as well as every line that contains this string. This is done as the latitude and longitude values of each hurricane report are contained in every line after this string. Each occurrence of these pairs of lines are piped into the second grep command, which filters out all instances of the string '--', to remove this from the pattern. 

# Following this the pairs of lines (where one line consists of the string 'Storm Location' and the other is the line containing the latitude and longitude values of that specific hurricane report) are piped into the following awk command. The lines containing the string 'Storm Location' are removed by checking if the line number is first even, and these are the lines that contain the location information of each storm (latitude and longitude values). The next gsub filter is used to remove any whitespaces which are replaced with nothing, and following this a comma is added to the latitude and longitude values extracted, in order to lead into the next field.

# Finally all these latitude and longitude pairs of values are piped into the sed command, which is used to remove any redundant tags before and after the values, and these lines are piped into the next sed command which removes any whitespace between the value and the unit.

latitudeAndLongitudeField=$(grep -A 1 "Storm Location" "$arg1" | grep -v '^--$' | awk 'NR%2==0 {gsub(/[[:space:]]*/, ""); print $0 ","}' | sed -e 's/<tr><td><B>//g' -e 's#</B></td></tr>##g' | sed -e 's/\([0-9]\+\)N/\1 N/g' -e 's/\([0-9]\+\)S/\1 S/g' -e 's/\([0-9]\+\)E/\1 E/g' -e 's/\([0-9]\+\)W/\1 W/g')





# The following line assigns all values of the minimum sea level pressure measured in millibars from the input xml file to the variable minSeaLevelPressureField

# The logic to this line of code is similar to the previous one where we obtained the latitude and longitude values for each hurricane report. This time each line containing the minimum sea level pressure is after a line in the xml file containing the string 'Min Sea Level Pressure'. We again use the grep command to get these pairs of lines, and these pairs are piped to a second grep command to remove the redundant string '--' from some lines.

# Like before, now we pipe the pairs of lines (one containing the string 'Min Sea Level Pressure' with some xml tags, and one containing the minimum sea level pressure measured in various units along with some xml tags) to the awk command to remove the line from each pair containing the string 'Min Sea Level Pressure' as we don't need this information, only the actual value. Again this is achieved through the use of a modulo check to see if the current line number is even, as all lines containing the minimum sea level pressure are even. We also remove any whitespaces which are replaced with nothing (used to get rid of leading whitespaces), and append a comma at the end of each line to lead into the next field. 

# Now we're just left with the line containing the minimum sea level pressure, but this line contains this value in the unit Hg as well as mb, but we only want it in millibars. These lines also contain redundant xml tags that we can remove. Hence, all these lines are piped to a first sed command that removes in the first check, the xml tags <tr><td> which are always before the relevant data value of the minimum sea levelpressure that we need (measured in mb), and the second check removes all the redundant information following the 'mb' part each line, where this information includes the minimum sea level pressure measured in theother unit in Hg, followed by some xml tags. The check for these decimal values measured in Hg is completed through the use of regular expressions, where we first check for zero or more occurrences of numbers between 0 to 9, followed by a decimal point, and a further zero or more occurrences of numbers from 0 to 9. This is followed by the remaining piece of text in the line (containing the string 'inHg' and further xml tags), and all of this is removed and replaced with nothing as we don't need any of this information. Therefore, now we're just left with the value of the minimum sea level pressure measured in mb, but since we removed all whitespaces in all lines containing the minimum sea level pressure, there will be no space between the value and the unit.

# Because of this we pipe all these lines to another sed command that adds a space between the value of the minimum sea level pressure measured in milliibars, and the unit (mb).

minSeaLevelPressureField=$(grep -A 1 "Min Sea Level Pressure" "$arg1" | grep -v '^--$' | awk 'NR%2==0 {gsub(/[[:space:]]*/, ""); print $0 ","}'| sed -e 's/<tr><td>//g' -e 's#;[0-9]*\.[0-9]*inHg</td></tr>##g' | sed 's/\([0-9]\+\)mb/\1 mb/g')





# The following line assigns all values of the maximum velocity of the winds in each hurricane report, from the input xml file to the variable maximumIntensityField. The values retrieved are only measured in knots. 

# The logic to this line of code is similar to the previous two fields, where we first use grep to get the next line after every line in the input kml file that contains the string 'Maxium Intensity' (using the -A option), as well as every line that contains this string. This is done, as like before the maximum intensity values for each hurricane report are contained in every line after this string, and each occurrence of these pairs of lines are piped into the second grep command, which filters out all instances of the string '--', to remove this from the pattern.

# The pairs of lines (where one line consists of the string 'Maxium Intensity' and the other is the line containing the maximum intensity values, measured in different units for the specific hurricane report) are piped into the following awk command. The awk command is used in a similar fashion as before in the field latitudeAndLongitudeField as well as the minSeaLevelPressureField, where lines containing the string 'Maxium Intensity' are removed, and any whitespaces in the remaining lines containing values for the maximum intensity values are replaced with nothing (hence they're also removed). The logic for completing this action was as before.

# Again these lines, now containing the maximum intensity values of various hurricane report, but measured in different units (knots, kph, and mph) as well as having additional xml tags that we need to remove, are piped into a sed command. This command like before, uses the same logic to remove any redundant xml tags and extra information of the maximum intensity of the hurricane report measured in different units. After this command is completed, we're now just left with the value of the maximum intensity measured in knots, but since we removed all whitespaces in all lines containing the maximum intensity, there will be no space between the value and the unit.

# Because of this we pipe all these lines to another sed command like before, that adds a space between the value of the maximum intensity measured in knots, and the unit (knots).

maximumIntensityField=$(grep -A 1 "Maxium Intensity" "$arg1" | grep -v '^--$' | awk 'NR%2==0 {gsub(/[[:space:]]*/, ""); print $0}' | sed -e 's/<tr><td>//g' -e's#;[0-9]*mph;[0-9]*kph</td></tr></table>]]>##g' | sed 's/\([0-9]\+\)knots/\1 knots/g')





# The paste command is used to concatenate the lines from timestampField, latitudeAndLongitudeField, minSeaLevelPressureField, and maximumIntensityField side be side without any delimiter. The '<()' syntax is used to treat the output of the echo commands as if they were files, and to ensure the fields are combined correctly. This produces the correct CSV format with seperate columns for each field, and this is appended to the output csv file.

paste -d '\0' <(echo "$timestampField") <(echo "$latitudeAndLongitudeField") <(echo "$minSeaLevelPressureField") <(echo "$maximumIntensityField") >>"$arg2"

