# Lever-Propelled Wheelchair Optimal Control

This repository contains the MATLAB code used for the study presented in the article titled:

**"The Influence of Lever-Propelled Wheelchair Parameters on Locomotion Performance: A Predictive Simulation Study"**

This research aims to understand how different lever-propelled wheelchair configurations affect locomotion performance, using predictive simulations to explore optimal control solutions.

## Authors

- **Artur Fernando de Vito Junior**, Centro Universitário FEI (FEI)
- **Fabrizio Leonardi**, Centro Universitário FEI (FEI)
- **Marko Ackermann**, Karlsruhe Institute of Technology (KIT)

## Publications

- **Title**: *The Influence of Lever-Propelled Wheelchair Parameters on Locomotion Performance: A Predictive Simulation Study*
  - **Status**: Under review (updates will be provided here)

## Requirements

To run the code in this repository, the following requirements must be met:

- **MATLAB** (version 2020b or newer recommended)
- **TOMLAB Optimization Toolbox** (used for optimal control and simulation)
- **Dependencies**:
  - Basic familiarity with MATLAB and numerical optimization techniques.
  - Install any additional required MATLAB toolboxes listed in the project dependencies.

## Setup Instructions

1. Clone this repository to your local machine:

    ```sh
    git clone https://github.com/arturvito/Lever-Propelled-Wheelchair-Optimal-Control.git
    ```

2. Make sure to add the relevant toolboxes and paths in MATLAB:

    ```matlab
    addpath(genpath('path_to_your_toolboxes'));
    ```

3. Verify all dependencies are installed before running the simulations.

## Running the Code

- **Step 1**: Load the required configurations by executing the setup script.
- **Step 2**: Execute the main script (`main_program.m`) to simulate the different configurations and parameters of lever-propelled wheelchairs.
- **Step 3**: Visualize results and generate plots to analyze locomotion performance.

Please refer to the comments in each script for further details on how to run specific parts of the code.

## Examples of Results

Below are some video demonstrations showing comparative results from our simulations:

- **Comparison between Configuration A0 and B2**: [Watch on YouTube](https://youtu.be/CGWXEokcE1M)
- **Comparison between A0 and B2 on an Inclined Plane**: [Watch on YouTube](https://youtu.be/csHft7sBg0w)
- **Comparison between C2 and B2**: [Watch on YouTube](https://youtu.be/8C14CtYMk_I)

## Repository Structure

- **`/src`**: Contains the source code for the simulations, including the main MATLAB scripts.
- **`/data`**: Data files used for different configurations in the simulations.
- **`/results`**: Generated results, plots, and data output.
- **`/docs`**: Documentation and additional details about the project.

## Contributions

Contributions are welcome! If you would like to contribute to this research, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

We are grateful to our institutions for providing support in conducting this research:

- Centro Universitário FEI (FEI)
- Karlsruhe Institute of Technology (KIT)

## Contact

If you have any questions, feel free to reach out:

- Artur Fernando de Vito Junior: [arturvito@FEINET.FEI.EDU.BR](mailto:arturvito@FEINET.FEI.EDU.BR)
