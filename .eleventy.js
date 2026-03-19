module.exports = function (eleventyConfig) {
  eleventyConfig.addFilter("date", (dateVal, format) => {
    const d = new Date(dateVal);
    if (format === "MMMM dd, yyyy") {
      return d.toLocaleDateString("en-GB", { year: "numeric", month: "long", day: "2-digit" });
    }
    return d.toLocaleDateString("en-GB");
  });

  return {
    dir: {
      input: "src",
      output: "_site",
      includes: "_includes",
    },
  };
};
