# Gini Index & Lorenz Curve


__Gini index__ is an index that measures inequalities in the distribution of resources, usually income.
The __Gini index__ is based on the Lorenz curve, indicating the share of cumulative resources according to the share of the cumulative population.
The figure below shows a real-time example expressing the *derivation of the Lorenz curve and the Gini coefficient for total income in 2011*.
__Gini index__ defined as the ratio between the area A between the curve and the first bisector to the sum of the areas A and B,
which is equal to 1/2. Therefore, __Gini index__ is two times area A.

![equation](https://latex.codecogs.com/gif.latex?%24%24G%3D%5Cfrac%7BA%7D%7BA&plus;B%7D%20%5Ctextrm%7B%20and%20%7D%20A&plus;B%3D%5Cfrac%7B1%7D%7B2%7D%20%5CRightarrow%20G%20%3D%202*A%20%24%24)

![wikipedia](https://upload.wikimedia.org/wikipedia/commons/e/e7/Lorenz_curve_global_income_2011.svg)



### Function estimating Gini index of a linear curve in chunks, by adding up the areas of the trapezoidal areas

* The four points F, G, H and I are forming a trapezoid, having respectively these coordinates, F and G belongs to the first bisector,
``` ```
![equation](https://latex.codecogs.com/gif.latex?%24F%28x_%7Bi-1%7D%2Cx_%7Bi-1%7D%29%2CG%28x_%7Bi%7D%2Cx_%7Bi%7D%29%2CH%28x_%7Bi%7D%2Cy_%7Bi%7D%29%2CI%28x_%7Bi-1%7D%2Cy_%7Bi-1%7D%29%20%24)



* Trapezoidal area is defined by,
``` ```
![equation](https://latex.codecogs.com/gif.latex?%24%24%28%5Ctextrm%7BLarge%20Base%7D&plus;%5Ctextrm%7BSmall%20Base%7D%29*%5Cfrac%7Bh%7D%7B2%7D%24)


* Small base calculated by the following formula,
``` ```
![equation](https://latex.codecogs.com/gif.latex?FI%3Dx_%7Bi-1%7D-y_%7Bi-1%7D)

* Large base calculated by the following formula,
``` ```
![equation](https://latex.codecogs.com/gif.latex?GH%3Dx_%7Bi%7D&plus;y_%7Bi%7D)

* Height calculated by the following formula,
``` ```
![equation](https://latex.codecogs.com/gif.latex?Hauteur%3Dx_%7Bi%7D-x_%7Bi-1%7D)


* After calculating the three necessary components (height, large base, small base) to compute the trapezoidal area, the total areas are summed.
``` ```
![equation](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%202*%5Csum_%7Bi%3D1%7D%5E%7Bn%7D%20%5Cfrac%7B%28x_%7Bi-1%7D-y_%7Bi-1%7D&plus;x_%7Bi%7D-y_%7Bi%7D%29%28x_%7Bi%7D-x_%7Bi-1%7D%29%7D%7B2%7D%20%26%3D%5Csum_%7Bi%3D1%7D%5E%7Bn%7D%28x_%7Bi%7Dx_%7Bi-1%7D-x_%7Bi-1%7D%5E2-y_%7Bi-1%7Dx_%7Bi%7D&plus;y_%7Bi-1%7Dx_%7Bi-1%7D&plus;x_%7Bi%7D%5E2-x_%7Bi%7Dx_%7Bi-1%7D-y_%7Bi%7Dx_%7Bi%7D&plus;y_%7Bi%7Dx_%7Bi-1%7D%29%5C%5C%20%26%3D%5Csum_%7Bi%3D1%7D%5E%7Bn%7D%20%28x_%7Bi%7D%5E2-x_%7Bi-1%7D%5E2%29-%20%5Csum_%7Bi%3D1%7D%5E%7Bn%7D%28x_%7Bi%7D-x_%7Bi-1%7D%29%28y_%7Bi-1%7D&plus;y_%7Bi%7D%29%5C%5C%20%26%3Dx_%7Bn%7D-x_%7B0%7D-%5Csum_%7Bi%3D1%7D%5E%7Bn%7D%28x_%7Bi%7D-x_%7Bi-1%7D%29%28y_%7Bi-1%7D&plus;y_%7Bi%7D%29%5C%5C%20%26%3D%20x_%7B0%7D%3D0%20%5Cend%7Balign*%7D)
