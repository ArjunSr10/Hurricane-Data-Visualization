<h1>Hurricane Data Visualization</h1>

<h2>Description</h2>
The aim of this project was to develop a Bash-based data extraction and visualization pipeline for storm reports contained in .kml files. The primary goal was to automate the creation of a neatly formatted CSV file containing key information from each storm report, including: <br/><br/>
- <b>UTC timestamp of the report</b><br/>
- <b>Geographic location (latitude and longitude)</b><br/>
- <b>Minimum sea level pressure</b><br/>
- <b>Maximum intensity</b><br/>
<br/>
The CSV output provides a structured format suitable for downstream analysis and visualization. Using this CSV, storm locations were plotted on a world map, providing a visual representation of each storm’s path and intensity.
<br />
<br/>
To ensure reproducibility and track progress, Git was used for version control. Regular commits allowed for continuous saving of both the Bash scripts and the project documentation, making it easy to revert to earlier versions if necessary.
<br />


<h2>🧠 Languages</h2>

- <b>Bash – for scripting the data extraction and processing pipeline</b>
- <b>Gnuplot script (.gpi) – for visualizing storm locations on a map</b>
- <b>Python – for additional plotting, e.g., plotting pressure trends</b>

<h2>🛠️ Utilities & Tools</h2>

- <b>Git – version control for tracking changes in scripts and documentation</b>
- <b>grep – pattern searching in text files</b>
- <b>sed – text substitution and formatting</b>
- <b>awk – text processing and field manipulation</b> 

<h2>Program walk-through:</h2>

<p align="center">
<b>To create the csv file (can change kml file to any to any of those in the materials folder, and name/location of output csv file): </b><br/>
<img src="https://live.staticflickr.com/65535/54837780044_c07450bf0e.jpg" height="80%" width="80%"/>
<br />
<br />
<b>Create storm plots (make sure name of csv file created before is the same, and can change name/location of storm plot image)</b>: <br/>
<img src="https://live.staticflickr.com/65535/54837804293_7373b79627.jpg" height="80%" width="80%"/>
<br />
<br />
<b>Example storm plot image for a012020.kml file: <br/>
<img src="https://live.staticflickr.com/65535/54837560001_1bcc43b3d1.jpg" height="80%" width="80%"/>
<br />
<br />

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
