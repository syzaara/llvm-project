//===-- RISCVProcessors.td - RISC-V Processors -------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// RISC-V processors supported.
//===----------------------------------------------------------------------===//

class RISCVTuneInfo {
  bits<8> PrefFunctionAlignment = 1;
  bits<8> PrefLoopAlignment = 1;

  // Information needed by LoopDataPrefetch.
  bits<16> CacheLineSize = 0;
  bits<16> PrefetchDistance = 0;
  bits<16> MinPrefetchStride = 1;
  bits<32> MaxPrefetchIterationsAhead = -1;

  bits<32> MinimumJumpTableEntries = 5;

  // Tail duplication threshold at -O3.
  bits<32> TailDupAggressiveThreshold = 6;
}

def RISCVTuneInfoTable : GenericTable {
  let FilterClass = "RISCVTuneInfo";
  let CppTypeName = "RISCVTuneInfo";
  let Fields = ["Name", "PrefFunctionAlignment", "PrefLoopAlignment",
                "CacheLineSize", "PrefetchDistance",
                "MinPrefetchStride", "MaxPrefetchIterationsAhead",
                "MinimumJumpTableEntries", "TailDupAggressiveThreshold"];
}

def getRISCVTuneInfo : SearchIndex {
  let Table = RISCVTuneInfoTable;
  let Key = ["Name"];
}

class GenericTuneInfo: RISCVTuneInfo;

class RISCVProcessorModel<string n,
                          SchedMachineModel m,
                          list<SubtargetFeature> f,
                          list<SubtargetFeature> tunef = [],
                          string default_march = "">
    :  ProcessorModel<n, m, f, tunef> {
  string DefaultMarch = default_march;
}

class RISCVTuneProcessorModel<string n,
                              SchedMachineModel m,
                              list<SubtargetFeature> tunef = [],
                              list<SubtargetFeature> f = []>
    : ProcessorModel<n, m, f,tunef>;

defvar GenericTuneFeatures = [TuneOptimizedNF2SegmentLoadStore];

def GENERIC_RV32 : RISCVProcessorModel<"generic-rv32",
                                       NoSchedModel,
                                       [Feature32Bit,
                                        FeatureStdExtI],
                                       GenericTuneFeatures>,
                   GenericTuneInfo;
def GENERIC_RV64 : RISCVProcessorModel<"generic-rv64",
                                       NoSchedModel,
                                       [Feature64Bit,
                                        FeatureStdExtI],
                                       GenericTuneFeatures>,
                   GenericTuneInfo;
// Support generic for compatibility with other targets. The triple will be used
// to change to the appropriate rv32/rv64 version.
def GENERIC : RISCVTuneProcessorModel<"generic", NoSchedModel>, GenericTuneInfo;

def ROCKET_RV32 : RISCVProcessorModel<"rocket-rv32",
                                      RocketModel,
                                      [Feature32Bit,
                                       FeatureStdExtI,
                                       FeatureStdExtZifencei,
                                       FeatureStdExtZicsr]>;
def ROCKET_RV64 : RISCVProcessorModel<"rocket-rv64",
                                      RocketModel,
                                      [Feature64Bit,
                                       FeatureStdExtI,
                                       FeatureStdExtZifencei,
                                       FeatureStdExtZicsr]>;
def ROCKET : RISCVTuneProcessorModel<"rocket",
                                     RocketModel>;

defvar SiFive7TuneFeatures = [TuneSiFive7, TuneNoDefaultUnroll,
                              TuneShortForwardBranchOpt,
                              FeaturePostRAScheduler];
def SIFIVE_7 : RISCVTuneProcessorModel<"sifive-7-series",
                                       SiFive7Model, SiFive7TuneFeatures>;

def SIFIVE_E20 : RISCVProcessorModel<"sifive-e20",
                                     RocketModel,
                                     [Feature32Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZicsr,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtM,
                                      FeatureStdExtC]>;

def SIFIVE_E21 : RISCVProcessorModel<"sifive-e21",
                                     RocketModel,
                                     [Feature32Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZicsr,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtM,
                                      FeatureStdExtA,
                                      FeatureStdExtC]>;

def SIFIVE_E24 : RISCVProcessorModel<"sifive-e24",
                                     RocketModel,
                                     [Feature32Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtM,
                                      FeatureStdExtA,
                                      FeatureStdExtF,
                                      FeatureStdExtC]>;

def SIFIVE_E31 : RISCVProcessorModel<"sifive-e31",
                                     RocketModel,
                                     [Feature32Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtZicsr,
                                      FeatureStdExtM,
                                      FeatureStdExtA,
                                      FeatureStdExtC]>;

def SIFIVE_E34 : RISCVProcessorModel<"sifive-e34",
                                     RocketModel,
                                     [Feature32Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtM,
                                      FeatureStdExtA,
                                      FeatureStdExtF,
                                      FeatureStdExtC]>;

def SIFIVE_E76 : RISCVProcessorModel<"sifive-e76",
                                     SiFive7Model,
                                     [Feature32Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtM,
                                      FeatureStdExtA,
                                      FeatureStdExtF,
                                      FeatureStdExtC],
                                     SiFive7TuneFeatures>;

def SIFIVE_S21 : RISCVProcessorModel<"sifive-s21",
                                     RocketModel,
                                     [Feature64Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZicsr,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtM,
                                      FeatureStdExtA,
                                      FeatureStdExtC]>;

def SIFIVE_S51 : RISCVProcessorModel<"sifive-s51",
                                     RocketModel,
                                     [Feature64Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZicsr,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtM,
                                      FeatureStdExtA,
                                      FeatureStdExtC]>;

def SIFIVE_S54 : RISCVProcessorModel<"sifive-s54",
                                      RocketModel,
                                      [Feature64Bit,
                                       FeatureStdExtI,
                                       FeatureStdExtZifencei,
                                       FeatureStdExtM,
                                       FeatureStdExtA,
                                       FeatureStdExtF,
                                       FeatureStdExtD,
                                       FeatureStdExtC]>;

def SIFIVE_S76 : RISCVProcessorModel<"sifive-s76",
                                     SiFive7Model,
                                     [Feature64Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtM,
                                      FeatureStdExtA,
                                      FeatureStdExtF,
                                      FeatureStdExtD,
                                      FeatureStdExtC,
                                      FeatureStdExtZihintpause],
                                     SiFive7TuneFeatures>;

def SIFIVE_U54 : RISCVProcessorModel<"sifive-u54",
                                     RocketModel,
                                     [Feature64Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtM,
                                      FeatureStdExtA,
                                      FeatureStdExtF,
                                      FeatureStdExtD,
                                      FeatureStdExtC]>;

def SIFIVE_U74 : RISCVProcessorModel<"sifive-u74",
                                     SiFive7Model,
                                     [Feature64Bit,
                                      FeatureStdExtI,
                                      FeatureStdExtZifencei,
                                      FeatureStdExtM,
                                      FeatureStdExtA,
                                      FeatureStdExtF,
                                      FeatureStdExtD,
                                      FeatureStdExtC],
                                     SiFive7TuneFeatures>;

defvar SiFiveX280TuneFeatures = !listconcat(SiFive7TuneFeatures,
                                            [TuneDLenFactor2,
                                             TuneOptimizedZeroStrideLoad,
                                             TuneOptimizedNF2SegmentLoadStore]);
def SIFIVE_X280 : RISCVProcessorModel<"sifive-x280", SiFive7Model,
                                      [Feature64Bit,
                                       FeatureStdExtI,
                                       FeatureStdExtZifencei,
                                       FeatureStdExtM,
                                       FeatureStdExtA,
                                       FeatureStdExtF,
                                       FeatureStdExtD,
                                       FeatureStdExtC,
                                       FeatureStdExtV,
                                       FeatureStdExtZvl512b,
                                       FeatureStdExtZfh,
                                       FeatureStdExtZvfh,
                                       FeatureStdExtZba,
                                       FeatureStdExtZbb],
                                      SiFiveX280TuneFeatures>;

defvar SiFiveP400TuneFeatures = [TuneNoDefaultUnroll,
                                 TuneConditionalCompressedMoveFusion,
                                 TuneLUIADDIFusion,
                                 TuneAUIPCADDIFusion,
                                 FeaturePostRAScheduler];

def SIFIVE_P450 : RISCVProcessorModel<"sifive-p450", SiFiveP400Model,
                                      !listconcat(RVA22U64Features,
                                      [FeatureStdExtZifencei,
                                       FeatureStdExtZihintntl,
                                       FeatureUnalignedScalarMem,
                                       FeatureUnalignedVectorMem]),
                                      SiFiveP400TuneFeatures>;

def SIFIVE_P470 : RISCVProcessorModel<"sifive-p470", SiFiveP400Model,
                                      !listconcat(RVA22U64Features,
                                      [FeatureStdExtV,
                                       FeatureStdExtZifencei,
                                       FeatureStdExtZihintntl,
                                       FeatureStdExtZvl128b,
                                       FeatureStdExtZvbb,
                                       FeatureStdExtZvknc,
                                       FeatureStdExtZvkng,
                                       FeatureStdExtZvksc,
                                       FeatureStdExtZvksg,
                                       FeatureVendorXSiFivecdiscarddlone,
                                       FeatureVendorXSiFivecflushdlone,
                                       FeatureUnalignedScalarMem,
                                       FeatureUnalignedVectorMem]),
                                      !listconcat(SiFiveP400TuneFeatures,
                                                  [TuneNoSinkSplatOperands])>;


def SIFIVE_P670 : RISCVProcessorModel<"sifive-p670", SiFiveP600Model,
                                      !listconcat(RVA22U64Features,
                                      [FeatureStdExtV,
                                       FeatureStdExtZifencei,
                                       FeatureStdExtZihintntl,
                                       FeatureStdExtZvl128b,
                                       FeatureStdExtZvbb,
                                       FeatureStdExtZvknc,
                                       FeatureStdExtZvkng,
                                       FeatureStdExtZvksc,
                                       FeatureStdExtZvksg,
                                       FeatureUnalignedScalarMem,
                                       FeatureUnalignedVectorMem]),
                                      [TuneNoDefaultUnroll,
                                       TuneConditionalCompressedMoveFusion,
                                       TuneLUIADDIFusion,
                                       TuneAUIPCADDIFusion,
                                       TuneNoSinkSplatOperands,
                                       FeaturePostRAScheduler]>;

def SYNTACORE_SCR1_BASE : RISCVProcessorModel<"syntacore-scr1-base",
                                              SyntacoreSCR1Model,
                                              [Feature32Bit,
                                               FeatureStdExtI,
                                               FeatureStdExtZicsr,
                                               FeatureStdExtZifencei,
                                               FeatureStdExtC],
                                              [TuneNoDefaultUnroll]>;

def SYNTACORE_SCR1_MAX : RISCVProcessorModel<"syntacore-scr1-max",
                                             SyntacoreSCR1Model,
                                             [Feature32Bit,
                                              FeatureStdExtI,
                                              FeatureStdExtZicsr,
                                              FeatureStdExtZifencei,
                                              FeatureStdExtM,
                                              FeatureStdExtC],
                                             [TuneNoDefaultUnroll]>;

def SYNTACORE_SCR3_RV32 : RISCVProcessorModel<"syntacore-scr3-rv32",
                                              SyntacoreSCR3RV32Model,
                                              [Feature32Bit,
                                               FeatureStdExtI,
                                               FeatureStdExtZicsr,
                                               FeatureStdExtZifencei,
                                               FeatureStdExtM,
                                               FeatureStdExtC],
                                              [TuneNoDefaultUnroll, FeaturePostRAScheduler]>;

def SYNTACORE_SCR3_RV64 : RISCVProcessorModel<"syntacore-scr3-rv64",
                                              SyntacoreSCR3RV64Model,
                                              [Feature64Bit,
                                               FeatureStdExtI,
                                               FeatureStdExtZicsr,
                                               FeatureStdExtZifencei,
                                               FeatureStdExtM,
                                               FeatureStdExtA,
                                               FeatureStdExtC],
                                              [TuneNoDefaultUnroll, FeaturePostRAScheduler]>;

def SYNTACORE_SCR4_RV32 : RISCVProcessorModel<"syntacore-scr4-rv32",
                                              SyntacoreSCR4RV32Model,
                                              [Feature32Bit,
                                               FeatureStdExtI,
                                               FeatureStdExtZicsr,
                                               FeatureStdExtZifencei,
                                               FeatureStdExtM,
                                               FeatureStdExtF,
                                               FeatureStdExtD,
                                               FeatureStdExtC],
                                              [TuneNoDefaultUnroll, FeaturePostRAScheduler]>;

def SYNTACORE_SCR4_RV64 : RISCVProcessorModel<"syntacore-scr4-rv64",
                                              SyntacoreSCR4RV64Model,
                                              [Feature64Bit,
                                               FeatureStdExtI,
                                               FeatureStdExtZicsr,
                                               FeatureStdExtZifencei,
                                               FeatureStdExtM,
                                               FeatureStdExtA,
                                               FeatureStdExtF,
                                               FeatureStdExtD,
                                               FeatureStdExtC],
                                              [TuneNoDefaultUnroll, FeaturePostRAScheduler]>;

def SYNTACORE_SCR5_RV32 : RISCVProcessorModel<"syntacore-scr5-rv32",
                                              SyntacoreSCR5RV32Model,
                                              [Feature32Bit,
                                               FeatureStdExtI,
                                               FeatureStdExtZicsr,
                                               FeatureStdExtZifencei,
                                               FeatureStdExtM,
                                               FeatureStdExtA,
                                               FeatureStdExtF,
                                               FeatureStdExtD,
                                               FeatureStdExtC],
                                              [TuneNoDefaultUnroll, FeaturePostRAScheduler]>;

def SYNTACORE_SCR5_RV64 : RISCVProcessorModel<"syntacore-scr5-rv64",
                                              SyntacoreSCR5RV64Model,
                                              [Feature64Bit,
                                               FeatureStdExtI,
                                               FeatureStdExtZicsr,
                                               FeatureStdExtZifencei,
                                               FeatureStdExtM,
                                               FeatureStdExtA,
                                               FeatureStdExtF,
                                               FeatureStdExtD,
                                               FeatureStdExtC],
                                              [TuneNoDefaultUnroll, FeaturePostRAScheduler]>;

def SYNTACORE_SCR7 : RISCVProcessorModel<"syntacore-scr7",
                                              SyntacoreSCR7Model,
                                              [Feature64Bit,
                                               FeatureStdExtI,
                                               FeatureStdExtZicsr,
                                               FeatureStdExtZifencei,
                                               FeatureStdExtM,
                                               FeatureStdExtA,
                                               FeatureStdExtF,
                                               FeatureStdExtD,
                                               FeatureStdExtC,
                                               FeatureStdExtV,
                                               FeatureStdExtZba,
                                               FeatureStdExtZbb,
                                               FeatureStdExtZbc,
                                               FeatureStdExtZbs,
                                               FeatureStdExtZkn],
                                              [TuneNoDefaultUnroll, FeaturePostRAScheduler]>;

def TENSTORRENT_ASCALON_D8 : RISCVProcessorModel<"tt-ascalon-d8",
                                                 NoSchedModel,
                                                 !listconcat(RVA23S64Features,
                                                 [FeatureStdExtSmaia,
                                                  FeatureStdExtSsaia,
                                                  FeatureStdExtSscofpmf,
                                                  FeatureStdExtSsstrict,
                                                  FeatureStdExtZfbfmin,
                                                  FeatureStdExtZfh,
                                                  FeatureStdExtZicsr,
                                                  FeatureStdExtZvbc,
                                                  FeatureStdExtZvfbfmin,
                                                  FeatureStdExtZvfbfwma,
                                                  FeatureStdExtZvfh,
                                                  FeatureStdExtZvkng,
                                                  FeatureStdExtZvl256b,
                                                  FeatureUnalignedScalarMem,
                                                  FeatureUnalignedVectorMem]),
                                                 [TuneNoDefaultUnroll,
                                                  TuneOptimizedZeroStrideLoad,
                                                  FeaturePostRAScheduler]>;

def VENTANA_VEYRON_V1 : RISCVProcessorModel<"veyron-v1",
                                            NoSchedModel,
                                            [Feature64Bit,
                                             FeatureStdExtI,
                                             FeatureStdExtZifencei,
                                             FeatureStdExtZicsr,
                                             FeatureStdExtZicntr,
                                             FeatureStdExtZihpm,
                                             FeatureStdExtZihintpause,
                                             FeatureStdExtM,
                                             FeatureStdExtA,
                                             FeatureStdExtF,
                                             FeatureStdExtD,
                                             FeatureStdExtC,
                                             FeatureStdExtZba,
                                             FeatureStdExtZbb,
                                             FeatureStdExtZbc,
                                             FeatureStdExtZbs,
                                             FeatureStdExtZicbom,
                                             FeatureStdExtZicbop,
                                             FeatureStdExtZicboz,
                                             FeatureVendorXVentanaCondOps],
                                             [TuneVentanaVeyron,
                                              TuneLUIADDIFusion,
                                              TuneAUIPCADDIFusion,
                                              TuneZExtHFusion,
                                              TuneZExtWFusion,
                                              TuneShiftedZExtWFusion,
                                              TuneLDADDFusion]>;

def XIANGSHAN_NANHU : RISCVProcessorModel<"xiangshan-nanhu",
                                          XiangShanNanHuModel,
                                          [Feature64Bit,
                                           FeatureStdExtI,
                                           FeatureStdExtZicsr,
                                           FeatureStdExtZifencei,
                                           FeatureStdExtM,
                                           FeatureStdExtA,
                                           FeatureStdExtF,
                                           FeatureStdExtD,
                                           FeatureStdExtC,
                                           FeatureStdExtZba,
                                           FeatureStdExtZbb,
                                           FeatureStdExtZbc,
                                           FeatureStdExtZbs,
                                           FeatureStdExtZkn,
                                           FeatureStdExtZksed,
                                           FeatureStdExtZksh,
                                           FeatureStdExtSvinval,
                                           FeatureStdExtZicbom,
                                           FeatureStdExtZicboz],
                                           [TuneNoDefaultUnroll,
                                            TuneZExtHFusion,
                                            TuneZExtWFusion,
                                            TuneShiftedZExtWFusion]>;

def SPACEMIT_X60 : RISCVProcessorModel<"spacemit-x60",
                                       NoSchedModel,
                                       !listconcat(RVA22S64Features,
                                       [FeatureStdExtV,
                                        FeatureStdExtSscofpmf,
                                        FeatureStdExtSstc,
                                        FeatureStdExtSvnapot,
                                        FeatureStdExtZbc,
                                        FeatureStdExtZbkc,
                                        FeatureStdExtZfh,
                                        FeatureStdExtZicond,
                                        FeatureStdExtZvfh,
                                        FeatureStdExtZvkt,
                                        FeatureStdExtZvl256b,
                                        FeatureUnalignedScalarMem]),
                                       [TuneDLenFactor2,
                                        TuneOptimizedNF2SegmentLoadStore,
                                        TuneOptimizedNF3SegmentLoadStore,
                                        TuneOptimizedNF4SegmentLoadStore]>;

def RP2350_HAZARD3 : RISCVProcessorModel<"rp2350-hazard3",
                                         NoSchedModel,
                                         [Feature32Bit,
                                          FeatureStdExtI,
                                          FeatureStdExtM,
                                          FeatureStdExtA,
                                          FeatureStdExtC,
                                          FeatureStdExtZicsr,
                                          FeatureStdExtZifencei,
                                          FeatureStdExtZba,
                                          FeatureStdExtZbb,
                                          FeatureStdExtZbs,
                                          FeatureStdExtZbkb,
                                          FeatureStdExtZcb,
                                          FeatureStdExtZcmp]>;
