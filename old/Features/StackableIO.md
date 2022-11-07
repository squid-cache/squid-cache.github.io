# Feature: Stackable I/O

  - **Goal**: Abstract the actual low-level I/O from the upper level
    protocols, allowing for correct SSL implementations etc.

  - **Status**: *Not started*

  - **ETA**: Unknown

## Details

Move away from the fd centric I/O model into a model using abstract
handles, allowing I/O layers to be stacked. Needed to make SSL I/O make
sense, and also for adding new transport mechanisms such as compression.

Currently the network I/O is very filedescriptor centric, which do not
fit very well with the needs of SSL and other middle layers where
protocol level I/O operations do not match exactly the actual I/O.

[CategoryFeature](/CategoryFeature#)
[CategoryWish](/CategoryWish#)
