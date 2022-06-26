int getNbEltExpandedByWidth(double width) => width < 300
    ? 1
    : width < 500
        ? 2
        : width < 800
            ? 3
            : 4;

int getNbEltByWidth(double width) => width < 600
    ? 1
    : width < 900
        ? 2
        : 3;
