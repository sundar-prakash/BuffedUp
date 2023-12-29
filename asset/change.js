const fs = require("fs");

// Read the JSON file
const filePath = "./dj.json";
const objects = require(filePath);
console.log(objects.length);
// Modify the objects
// for (let i = 0; i < objects.length; i++) {
//   const obj = objects[i];
//   for (let prop in obj) {
//     if (
//       obj.hasOwnProperty(prop) &&
//       obj[prop] !== null &&
//       !isNaN(obj[prop]) &&
//       prop !== "phoneNumber" // Exclude 'phoneNumber'
//     ) {
//       obj[prop] = +obj[prop];
//     }
//   }
// }

// // Write the modified JSON back to the file
// fs.writeFile(filePath, JSON.stringify(objects, null, 2), (err) => {
//   if (err) {
//     console.error("Error writing to file:", err);
//   } else {
//     console.log("JSON file updated successfully!");
//   }
// });
