# CG HW 1
## Completed Task
### STANDARD
- [x] (25%) Correctly complete the line algorithm.
- [x] (25%) Correctly complete the circle algorithm.
- [x] (15%) Correctly complete the ellipse algorithm.
- [x] (15%) Correctly complete the curve algorithm.
- [x] (20%) Correctly complete the eraser.
### BONUS 
- [x] A Palette
- [x] A Sprays ~~and active ver~~
- [x] boundary checks in the `drawpoint` function
### screenshots & how I completed these tasks
### STANDARD
#### (25%) Correctly complete the line algorithm.
I use mid-point line algorithm to implement this task.
By calculating the horizontal and vertical distances between two points, then adjusting the x and y positions step by step while tracking errors to ensure the line stays smooth and accurate.
#### (25%) Correctly complete the circle algorithm.
I use mid-point circle algorithm to implement this task.
By starting from the top and calculating each new point based on a decision variable, while using symmetry to plot points around the center.
#### (15%) Correctly complete the ellipse algorithm.
I follow the website as follow to implement this task.

* https://www.geeksforgeeks.org/midpoint-ellipse-drawing-algorithm/
* https://www.javatpoint.com/computer-graphics-midpoint-ellipse-algorithm

By calculating points in two regions, adjusting the x and y coordinates based on decision variables, and using symmetry to plot points around the center.
#### (15%) Correctly complete the curve algorithm.
I follow the website as follow to implement this task.

* https://javascript.info/bezier-curve

By calculating points along a Bezier path between four control points and plotting them at regular intervals to form the curve.
#### (20%) Correctly complete the eraser.
First, find the x and y of the two largest and smallest x, y respectively, and use the for-loop to clearing the rectangular area between two points
### BONUS 
#### 1. A Palette
I create some ShapeButtons for colorButtons, and use a global variavble selectedColor to store the current color.
and add a parameter 'color c' to make the shape and pencil have its color.
#### 2. A Sprays ~~and an active ver.~~
I implemented the Sprays function by randomly placing points within a circular area around a given center, ensuring the points stay within the specified radius.

At first, the sprays points would move all the time. I thought it is interesting ~~and disgusting~~, so I kept it and called it **Straightened steel wire ball**. XDDDDDDD

Then I realized that it would randomize those points when rendering, so I saved those random points into an ArrayList when generating sprays points, so that it wouldn't update every time it rendered, and then I could have a normal sprays. Hurray!!!!

#### 3. ?, boundary checks in the `drawpoint` function
I added boundary checks in the `drawpoint` function, so it no longer draws outside the canvas.