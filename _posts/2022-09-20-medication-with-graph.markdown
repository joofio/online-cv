---
title:  "Medication Definition on graph networks"
date:   2022-09-20 12:00:00 +0000
categories: medication-definition graph 
toc: true
---

Standardized information regarding drugs around the world and Europe is not new. However, several ways of implementing drug information are possible. Even though we can almost agree on the basis of the information: strength, ingredient(s) and form, there is almost an infinite way of combining these with other product characteristics to create a new drug representation or grouping. A few examples around Europe are:
- CNPEM in Portugal (strength + ingredient(s) + form + package size)
- VOS Group in Belgium (strength + ingredient(s) + route)
- IDMP's Medicinal Product (strength + ingredient(s) + Brand + form)

There are only three examples, but I believe that almost every country has a similar grouping, differing on additional characteristics.

Being that the most common way of cataloguing product lists is a spreadsheet-like manner, where every possible drug combination is registered with its own properties and given a unique code, the relationship between products becomes very difficult to handle.

Moreover, taking that most countries in Europe that I know of, have e-prescription and almost everyone provides the possibility of prescribing by active principle. So, a prescription is made for example:
500 mg paracetamol tablet, **which has one code**.
But in the hospital pharmacy, it will be dispensed a tablet of the brand X, which is an instance of a 500 mg paracetamol tablet, **which has another code**.

It happens also in the community pharmacies, where a box of the brand X will be supplied, **which has a third different code**. It has common characteristics with 500 mg paracetamol but is a more specific instance of that concept:
(brand + ingredient + strength + form + package size).
So how to handle these relationships and building blocks: **graph networks**.

<figure>
<img src=../assets/img/medication-graph/mg-1.png  style="width:100%">
<figcaption align = "center"><b>Drug relationship on graph network</b></figcaption>
</figure>


Through this methodology, it is possible to quickly map all concepts and instances stemming from a certain root.

An easy example of usage is that of an allergy, where it can declare an allergy to any drug instance in the tree, that it can be automatically traced to every branch.