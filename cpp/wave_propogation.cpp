#include "wave_propogation.hpp"

void wave_propogation_single(int num_steps, int scale, float damping,
                             float initial_P, int stop_step, float *_P) {

  float omega = 3.0 / (2.0 * M_PI);
  int size_x = 2 * scale + 1;
  int size_y = 2 * scale + 1;
  int vertPos = scale;
  int horizPos = scale;

  int i = 0;
  int j = 0;
  int k = 0;
  int step = 0;

// V velocity
// P presure
// Initialization
#ifndef __APPLE__
  float(*P)[size_y] = (float(*)[size_y])_P;
#else
  // Clang doesn't like weird pointer assignments so we create a new 2d array
  float P[size_x][size_y];
#endif
  float V[size_x][size_y][4];

  for (i = 0; i < size_x; i++) {
    for (j = 0; j < size_y; j++) {
      P[i][j] = 0.0;
      for (k = 0; k < 4; k++)
        V[i][j][k] = 0.0;
    }
  }

  P[vertPos][horizPos] = initial_P;
  auto start = std::chrono::high_resolution_clock::now();
  for (step = 0; step < num_steps; step++) {
    if (step <= stop_step)
      P[vertPos][horizPos] = initial_P * sin(omega * step);
    for (i = 0; i < size_x; i++) {
      for (j = 0; j < size_y; j++) {
        V[i][j][0] = (i > 0 ? V[i][j][0] + P[i][j] - P[i - 1][j] : P[i][j]);
        V[i][j][1] =
            (j < size_x - 1 ? V[i][j][1] + P[i][j] - P[i][j + 1] : P[i][j]);
        V[i][j][2] =
            (i < size_y - 1 ? V[i][j][2] + P[i][j] - P[i + 1][j] : P[i][j]);
        V[i][j][3] = (j > 0 ? V[i][j][3] + P[i][j] - P[i][j - 1] : P[i][j]);
      }
    }

    for (i = 0; i < size_x; i++) {
      for (j = 0; j < size_y; j++) {
        P[i][j] -=
            0.5 * damping * (V[i][j][0] + V[i][j][1] + V[i][j][2] + V[i][j][3]);
      }
    }
  }

#ifdef __APPLE__
  // Then we copy from out array P into out output pointer _P
  for (i = 0; i < size_x; i++) {
    for (j = 0; j < size_y; j++) {
      _P[i * size_x + j] = P[i][j];
    }
  }
#endif

  std::chrono::duration<double> elapsed_full =
      (std::chrono::high_resolution_clock::now() - start);
  std::cerr << elapsed_full.count() << " sec" << std::endl;
  std::cerr.imbue(std::locale(""));
  std::cerr << num_steps / elapsed_full.count() << " Hz" << std::endl;
}

void wave_propogation_omp(int num_steps, int scale, float damping,
                          float initial_P, int stop_step, float *_P) {
#ifdef __APPLE__

  std::cerr << "\033[1;31mNot Supported on this machine\nUsing single core "
               "version \033[0m"
            << std::endl;
  wave_propogation_single(num_steps, scale, damping, initial_P, stop_step, _P);
#else
  float omega = 3.0 / (2.0 * M_PI);
  int size_x = 2 * scale + 1;
  int size_y = 2 * scale + 1;
  int vertPos = scale;
  int horizPos = scale;

  int i = 0;
  int j = 0;
  int k = 0;
  int step = 0;

  // V velocity
  // P presure
  // Initialization
  float(*P)[size_y] = (float(*)[size_y])_P;
  float V[size_x][size_y][4];
  auto start = std::chrono::high_resolution_clock::now();

#pragma omp parallel for private(i, j) num_threads(4)
  for (i = 0; i < size_x; i++) {
    for (j = 0; j < size_y; j++) {
      P[i][j] = 0.0;
      for (k = 0; k < 4; k++)
        V[i][j][k] = 0.0;
    }
  }

  P[vertPos][horizPos] = initial_P;

  for (step = 0; step < num_steps; step++) {
    if (step <= stop_step)
      P[vertPos][horizPos] = initial_P * sin(omega * step);
#pragma omp parallel for private(i, j) num_threads(4)
    for (i = 0; i < size_x; i++) {
      for (j = 0; j < size_y; j++) {
        V[i][j][0] = (i > 0 ? V[i][j][0] + P[i][j] - P[i - 1][j] : P[i][j]);
        V[i][j][1] =
            (j < size_x - 1 ? V[i][j][1] + P[i][j] - P[i][j + 1] : P[i][j]);
        V[i][j][2] =
            (i < size_y - 1 ? V[i][j][2] + P[i][j] - P[i + 1][j] : P[i][j]);
        V[i][j][3] = (j > 0 ? V[i][j][3] + P[i][j] - P[i][j - 1] : P[i][j]);
      }
    }

#pragma omp parallel for private(i, j) num_threads(4)
    for (i = 0; i < size_x; i++) {
      for (j = 0; j < size_y; j++) {
        P[i][j] -=
            0.5 * damping * (V[i][j][0] + V[i][j][1] + V[i][j][2] + V[i][j][3]);
      }
    }
  }

  std::chrono::duration<double> elapsed_full =
      (std::chrono::high_resolution_clock::now() - start);
  std::cerr << elapsed_full.count() << " sec" << std::endl;
  std::cerr.imbue(std::locale(""));
  std::cerr << num_steps / elapsed_full.count() << " Hz" << std::endl;
#endif
}
