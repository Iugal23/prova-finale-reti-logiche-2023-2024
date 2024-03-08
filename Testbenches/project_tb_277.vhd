-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_277 is
end project_tb_277;

architecture project_tb_arch_277 of project_tb_277 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 590;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (60,0,235,0,206,0,248,0,0,0,18,0,29,0,151,0,0,0,0,0,0,0,73,0,25,0,44,0,67,0,66,0,96,0,220,0,102,0,189,0,0,0,255,0,65,0,227,0,214,0,33,0,189,0,167,0,0,0,22,0,0,0,0,0,160,0,0,0,13,0,132,0,115,0,130,0,0,0,109,0,172,0,158,0,237,0,0,0,242,0,252,0,169,0,26,0,28,0,120,0,171,0,189,0,81,0,97,0,39,0,0,0,0,0,213,0,76,0,233,0,250,0,187,0,127,0,190,0,185,0,167,0,12,0,58,0,74,0,0,0,89,0,0,0,0,0,80,0,246,0,49,0,166,0,155,0,150,0,107,0,112,0,226,0,0,0,68,0,47,0,0,0,15,0,21,0,192,0,56,0,190,0,43,0,214,0,0,0,0,0,161,0,64,0,184,0,160,0,9,0,0,0,0,0,225,0,7,0,41,0,0,0,181,0,157,0,0,0,69,0,48,0,30,0,17,0,163,0,0,0,99,0,100,0,0,0,103,0,234,0,138,0,230,0,227,0,103,0,98,0,93,0,208,0,183,0,150,0,169,0,103,0,44,0,177,0,251,0,0,0,21,0,0,0,137,0,135,0,43,0,76,0,45,0,0,0,163,0,118,0,79,0,92,0,232,0,37,0,11,0,228,0,167,0,109,0,0,0,83,0,78,0,0,0,139,0,44,0,144,0,35,0,181,0,190,0,90,0,102,0,96,0,178,0,156,0,0,0,205,0,72,0,0,0,77,0,224,0,6,0,243,0,78,0,84,0,0,0,128,0,194,0,18,0,7,0,49,0,10,0,91,0,0,0,0,0,112,0,78,0,229,0,33,0,74,0,92,0,122,0,189,0,90,0,103,0,0,0,0,0,0,0,96,0,217,0,65,0,198,0,88,0,66,0,20,0,183,0,100,0,126,0,0,0,138,0,104,0,143,0,236,0,123,0,108,0,0,0,181,0,255,0,180,0,0,0,214,0,0,0,160,0,37,0,0,0,0,0,177,0,213,0,59,0,60,0,127,0,0,0,40,0,48,0,251,0,0,0,152,0,0,0,10,0,0,0,253,0,123,0,241,0,74,0,13,0,237,0,51,0,240,0,209,0,0,0,128,0,223,0,138,0,0,0,200,0,102,0,191,0,141,0,147,0,78,0,231,0,74,0,189,0,119,0,0,0,0,0,1,0,239,0,200,0,7,0,90,0,0,0,43,0,45,0,163,0,12,0,108,0,13,0,171,0,193,0,232,0,74,0,0,0,164,0,0,0,154,0,189,0,240,0,35,0,166,0,0,0,226,0,254,0,112,0,186,0,93,0,122,0,47,0,73,0,145,0,134,0,223,0,22,0,47,0,182,0,220,0,86,0,58,0,205,0,39,0,36,0,184,0,188,0,95,0,92,0,20,0,218,0,81,0,57,0,59,0,0,0,178,0,119,0,126,0,89,0,0,0,0,0,0,0,145,0,66,0,200,0,0,0,71,0,0,0,122,0,44,0,35,0,148,0,211,0,227,0,27,0,0,0,19,0,114,0,212,0,195,0,148,0,156,0,238,0,85,0,242,0,30,0,207,0,141,0,192,0,0,0,215,0,0,0,131,0,115,0,0,0,53,0,226,0,129,0,240,0,26,0,157,0,139,0,0,0,18,0,233,0,23,0,237,0,185,0,0,0,41,0,243,0,200,0,76,0,37,0,0,0,197,0,33,0,155,0,230,0,0,0,119,0,87,0,80,0,72,0,245,0,178,0,253,0,79,0,0,0,0,0,0,0,106,0,44,0,184,0,58,0,209,0,153,0,195,0,0,0,215,0,38,0,178,0,36,0,144,0,0,0,123,0,0,0,173,0,92,0,0,0,0,0,250,0,115,0,28,0,254,0,8,0,123,0,0,0,66,0,120,0,13,0,87,0,57,0,0,0,0,0,0,0,78,0,0,0,0,0,27,0,154,0,0,0,169,0,9,0,169,0,20,0,33,0,76,0,0,0,0,0,2,0,236,0,144,0,102,0,132,0,193,0,3,0,29,0,0,0,120,0,230,0,154,0,13,0,5,0,89,0,45,0,79,0,211,0,62,0,104,0,84,0,84,0,31,0,206,0,0,0,220,0,246,0,145,0,12,0,66,0,158,0,13,0,56,0,0,0,99,0,28,0,130,0,255,0,243,0,28,0,63,0,0,0,44,0,146,0,0,0,171,0,232,0,126,0,126,0,121,0,0,0,147,0,205,0,191,0,235,0,28,0,217,0,97,0,135,0,239,0,105,0,0,0,191,0,81,0,0,0,165,0,109,0,98,0,227,0,0,0,205,0,0,0,189,0,120,0,243,0,214,0,0,0,0,0,111,0,218,0,56,0,138,0,224,0,178,0,18,0,34,0,25,0,72,0,0,0,0,0,200,0,178,0,24,0,141,0,101,0,221,0,73,0,224,0,74,0,135,0,167,0,151,0,0,0,2,0,0,0,20,0,34,0,228,0,73,0,153,0,180,0,0,0,141,0,228,0,102,0,0,0,25,0,222,0,103,0,29,0,0,0,235,0,172,0,230,0,204,0,25,0,207,0,238,0,153,0,68,0,202,0,76,0,125,0,0,0,181,0,201,0,104,0,236,0,49,0,141,0,151,0);
signal scenario_full  : scenario_type := (60,31,235,31,206,31,248,31,248,30,18,31,29,31,151,31,151,30,151,29,151,28,73,31,25,31,44,31,67,31,66,31,96,31,220,31,102,31,189,31,189,30,255,31,65,31,227,31,214,31,33,31,189,31,167,31,167,30,22,31,22,30,22,29,160,31,160,30,13,31,132,31,115,31,130,31,130,30,109,31,172,31,158,31,237,31,237,30,242,31,252,31,169,31,26,31,28,31,120,31,171,31,189,31,81,31,97,31,39,31,39,30,39,29,213,31,76,31,233,31,250,31,187,31,127,31,190,31,185,31,167,31,12,31,58,31,74,31,74,30,89,31,89,30,89,29,80,31,246,31,49,31,166,31,155,31,150,31,107,31,112,31,226,31,226,30,68,31,47,31,47,30,15,31,21,31,192,31,56,31,190,31,43,31,214,31,214,30,214,29,161,31,64,31,184,31,160,31,9,31,9,30,9,29,225,31,7,31,41,31,41,30,181,31,157,31,157,30,69,31,48,31,30,31,17,31,163,31,163,30,99,31,100,31,100,30,103,31,234,31,138,31,230,31,227,31,103,31,98,31,93,31,208,31,183,31,150,31,169,31,103,31,44,31,177,31,251,31,251,30,21,31,21,30,137,31,135,31,43,31,76,31,45,31,45,30,163,31,118,31,79,31,92,31,232,31,37,31,11,31,228,31,167,31,109,31,109,30,83,31,78,31,78,30,139,31,44,31,144,31,35,31,181,31,190,31,90,31,102,31,96,31,178,31,156,31,156,30,205,31,72,31,72,30,77,31,224,31,6,31,243,31,78,31,84,31,84,30,128,31,194,31,18,31,7,31,49,31,10,31,91,31,91,30,91,29,112,31,78,31,229,31,33,31,74,31,92,31,122,31,189,31,90,31,103,31,103,30,103,29,103,28,96,31,217,31,65,31,198,31,88,31,66,31,20,31,183,31,100,31,126,31,126,30,138,31,104,31,143,31,236,31,123,31,108,31,108,30,181,31,255,31,180,31,180,30,214,31,214,30,160,31,37,31,37,30,37,29,177,31,213,31,59,31,60,31,127,31,127,30,40,31,48,31,251,31,251,30,152,31,152,30,10,31,10,30,253,31,123,31,241,31,74,31,13,31,237,31,51,31,240,31,209,31,209,30,128,31,223,31,138,31,138,30,200,31,102,31,191,31,141,31,147,31,78,31,231,31,74,31,189,31,119,31,119,30,119,29,1,31,239,31,200,31,7,31,90,31,90,30,43,31,45,31,163,31,12,31,108,31,13,31,171,31,193,31,232,31,74,31,74,30,164,31,164,30,154,31,189,31,240,31,35,31,166,31,166,30,226,31,254,31,112,31,186,31,93,31,122,31,47,31,73,31,145,31,134,31,223,31,22,31,47,31,182,31,220,31,86,31,58,31,205,31,39,31,36,31,184,31,188,31,95,31,92,31,20,31,218,31,81,31,57,31,59,31,59,30,178,31,119,31,126,31,89,31,89,30,89,29,89,28,145,31,66,31,200,31,200,30,71,31,71,30,122,31,44,31,35,31,148,31,211,31,227,31,27,31,27,30,19,31,114,31,212,31,195,31,148,31,156,31,238,31,85,31,242,31,30,31,207,31,141,31,192,31,192,30,215,31,215,30,131,31,115,31,115,30,53,31,226,31,129,31,240,31,26,31,157,31,139,31,139,30,18,31,233,31,23,31,237,31,185,31,185,30,41,31,243,31,200,31,76,31,37,31,37,30,197,31,33,31,155,31,230,31,230,30,119,31,87,31,80,31,72,31,245,31,178,31,253,31,79,31,79,30,79,29,79,28,106,31,44,31,184,31,58,31,209,31,153,31,195,31,195,30,215,31,38,31,178,31,36,31,144,31,144,30,123,31,123,30,173,31,92,31,92,30,92,29,250,31,115,31,28,31,254,31,8,31,123,31,123,30,66,31,120,31,13,31,87,31,57,31,57,30,57,29,57,28,78,31,78,30,78,29,27,31,154,31,154,30,169,31,9,31,169,31,20,31,33,31,76,31,76,30,76,29,2,31,236,31,144,31,102,31,132,31,193,31,3,31,29,31,29,30,120,31,230,31,154,31,13,31,5,31,89,31,45,31,79,31,211,31,62,31,104,31,84,31,84,31,31,31,206,31,206,30,220,31,246,31,145,31,12,31,66,31,158,31,13,31,56,31,56,30,99,31,28,31,130,31,255,31,243,31,28,31,63,31,63,30,44,31,146,31,146,30,171,31,232,31,126,31,126,31,121,31,121,30,147,31,205,31,191,31,235,31,28,31,217,31,97,31,135,31,239,31,105,31,105,30,191,31,81,31,81,30,165,31,109,31,98,31,227,31,227,30,205,31,205,30,189,31,120,31,243,31,214,31,214,30,214,29,111,31,218,31,56,31,138,31,224,31,178,31,18,31,34,31,25,31,72,31,72,30,72,29,200,31,178,31,24,31,141,31,101,31,221,31,73,31,224,31,74,31,135,31,167,31,151,31,151,30,2,31,2,30,20,31,34,31,228,31,73,31,153,31,180,31,180,30,141,31,228,31,102,31,102,30,25,31,222,31,103,31,29,31,29,30,235,31,172,31,230,31,204,31,25,31,207,31,238,31,153,31,68,31,202,31,76,31,125,31,125,30,181,31,201,31,104,31,236,31,49,31,141,31,151,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
