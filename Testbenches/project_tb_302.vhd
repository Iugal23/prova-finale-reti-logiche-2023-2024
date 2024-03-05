-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 618;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,136,0,217,0,0,0,172,0,18,0,0,0,0,0,68,0,74,0,0,0,0,0,254,0,0,0,0,0,0,0,160,0,163,0,158,0,146,0,112,0,233,0,98,0,254,0,0,0,202,0,91,0,34,0,120,0,153,0,49,0,228,0,239,0,151,0,64,0,249,0,44,0,152,0,0,0,23,0,189,0,187,0,0,0,87,0,88,0,219,0,0,0,140,0,20,0,184,0,112,0,0,0,214,0,68,0,101,0,161,0,0,0,0,0,55,0,0,0,143,0,17,0,0,0,159,0,149,0,0,0,95,0,0,0,205,0,0,0,0,0,186,0,0,0,103,0,59,0,75,0,0,0,223,0,60,0,50,0,0,0,8,0,37,0,180,0,43,0,0,0,0,0,72,0,0,0,65,0,67,0,3,0,49,0,0,0,50,0,75,0,162,0,41,0,19,0,0,0,0,0,91,0,13,0,158,0,226,0,91,0,108,0,55,0,29,0,156,0,210,0,101,0,241,0,207,0,0,0,64,0,198,0,0,0,165,0,2,0,154,0,250,0,131,0,224,0,236,0,0,0,128,0,0,0,75,0,190,0,153,0,165,0,0,0,164,0,0,0,35,0,159,0,150,0,193,0,44,0,188,0,244,0,0,0,111,0,9,0,80,0,0,0,24,0,132,0,167,0,6,0,9,0,36,0,0,0,0,0,207,0,214,0,82,0,122,0,224,0,143,0,9,0,64,0,170,0,97,0,0,0,116,0,122,0,38,0,138,0,32,0,197,0,106,0,20,0,0,0,230,0,243,0,190,0,92,0,0,0,0,0,233,0,160,0,0,0,165,0,157,0,171,0,0,0,203,0,154,0,13,0,33,0,0,0,222,0,0,0,25,0,99,0,13,0,171,0,121,0,224,0,192,0,48,0,159,0,20,0,184,0,102,0,167,0,42,0,198,0,52,0,80,0,188,0,227,0,0,0,194,0,206,0,188,0,164,0,0,0,74,0,0,0,249,0,247,0,132,0,160,0,157,0,246,0,94,0,101,0,0,0,133,0,131,0,86,0,0,0,0,0,188,0,202,0,139,0,244,0,20,0,106,0,40,0,0,0,190,0,1,0,166,0,195,0,66,0,38,0,179,0,0,0,251,0,8,0,102,0,158,0,178,0,207,0,108,0,231,0,246,0,171,0,0,0,19,0,213,0,28,0,109,0,102,0,0,0,222,0,26,0,198,0,76,0,244,0,110,0,202,0,75,0,0,0,138,0,197,0,53,0,218,0,44,0,0,0,218,0,12,0,0,0,147,0,168,0,227,0,33,0,204,0,0,0,0,0,232,0,212,0,240,0,114,0,0,0,76,0,108,0,234,0,253,0,94,0,200,0,59,0,114,0,102,0,177,0,29,0,196,0,216,0,69,0,116,0,40,0,0,0,57,0,0,0,140,0,236,0,158,0,203,0,76,0,42,0,198,0,202,0,23,0,1,0,76,0,93,0,240,0,0,0,140,0,0,0,114,0,80,0,145,0,21,0,121,0,0,0,182,0,219,0,187,0,115,0,47,0,155,0,0,0,146,0,160,0,0,0,90,0,70,0,195,0,44,0,144,0,252,0,198,0,0,0,193,0,89,0,68,0,0,0,0,0,172,0,196,0,174,0,227,0,0,0,154,0,0,0,44,0,28,0,154,0,22,0,236,0,61,0,0,0,228,0,215,0,130,0,202,0,254,0,0,0,206,0,219,0,0,0,164,0,253,0,37,0,184,0,62,0,210,0,113,0,180,0,116,0,182,0,38,0,17,0,252,0,202,0,148,0,0,0,0,0,117,0,44,0,0,0,176,0,71,0,40,0,0,0,133,0,16,0,254,0,94,0,118,0,169,0,24,0,85,0,251,0,201,0,73,0,0,0,134,0,131,0,109,0,86,0,38,0,185,0,153,0,32,0,73,0,34,0,227,0,0,0,145,0,82,0,0,0,100,0,173,0,145,0,255,0,117,0,185,0,30,0,68,0,216,0,196,0,0,0,53,0,234,0,99,0,173,0,11,0,0,0,0,0,0,0,0,0,155,0,228,0,24,0,60,0,107,0,0,0,0,0,41,0,65,0,0,0,29,0,240,0,0,0,204,0,0,0,61,0,189,0,73,0,104,0,228,0,105,0,92,0,51,0,232,0,185,0,18,0,60,0,147,0,196,0,127,0,39,0,243,0,234,0,213,0,0,0,156,0,233,0,232,0,158,0,224,0,176,0,229,0,92,0,164,0,101,0,0,0,91,0,163,0,61,0,120,0,208,0,38,0,0,0,24,0,88,0,239,0,90,0,124,0,92,0,10,0,0,0,200,0,182,0,58,0,0,0,96,0,55,0,222,0,0,0,228,0,133,0,229,0,190,0,40,0,0,0,0,0,0,0,0,0,39,0,9,0,0,0,248,0,0,0,0,0,5,0,242,0,0,0,255,0,0,0,146,0,153,0,1,0,176,0,131,0,255,0,103,0,8,0,14,0,33,0,0,0,192,0,0,0,0,0,128,0,98,0,191,0,119,0,240,0,0,0,0,0,227,0,71,0,106,0,0,0,231,0,0,0,244,0,32,0,144,0,0,0,145,0,34,0,97,0,167,0,218,0,0,0,159,0,7,0,234,0,242,0,176,0,159,0,95,0,244,0,76,0,247,0,216,0,7,0,177,0,114,0,248,0,33,0,8,0,54,0,72,0,52,0,138,0,58,0,66,0,198,0,89,0,0,0,185,0,0,0,30,0,0,0,171,0,107,0,187,0,125,0);
signal scenario_full  : scenario_type := (0,0,0,0,136,31,217,31,217,30,172,31,18,31,18,30,18,29,68,31,74,31,74,30,74,29,254,31,254,30,254,29,254,28,160,31,163,31,158,31,146,31,112,31,233,31,98,31,254,31,254,30,202,31,91,31,34,31,120,31,153,31,49,31,228,31,239,31,151,31,64,31,249,31,44,31,152,31,152,30,23,31,189,31,187,31,187,30,87,31,88,31,219,31,219,30,140,31,20,31,184,31,112,31,112,30,214,31,68,31,101,31,161,31,161,30,161,29,55,31,55,30,143,31,17,31,17,30,159,31,149,31,149,30,95,31,95,30,205,31,205,30,205,29,186,31,186,30,103,31,59,31,75,31,75,30,223,31,60,31,50,31,50,30,8,31,37,31,180,31,43,31,43,30,43,29,72,31,72,30,65,31,67,31,3,31,49,31,49,30,50,31,75,31,162,31,41,31,19,31,19,30,19,29,91,31,13,31,158,31,226,31,91,31,108,31,55,31,29,31,156,31,210,31,101,31,241,31,207,31,207,30,64,31,198,31,198,30,165,31,2,31,154,31,250,31,131,31,224,31,236,31,236,30,128,31,128,30,75,31,190,31,153,31,165,31,165,30,164,31,164,30,35,31,159,31,150,31,193,31,44,31,188,31,244,31,244,30,111,31,9,31,80,31,80,30,24,31,132,31,167,31,6,31,9,31,36,31,36,30,36,29,207,31,214,31,82,31,122,31,224,31,143,31,9,31,64,31,170,31,97,31,97,30,116,31,122,31,38,31,138,31,32,31,197,31,106,31,20,31,20,30,230,31,243,31,190,31,92,31,92,30,92,29,233,31,160,31,160,30,165,31,157,31,171,31,171,30,203,31,154,31,13,31,33,31,33,30,222,31,222,30,25,31,99,31,13,31,171,31,121,31,224,31,192,31,48,31,159,31,20,31,184,31,102,31,167,31,42,31,198,31,52,31,80,31,188,31,227,31,227,30,194,31,206,31,188,31,164,31,164,30,74,31,74,30,249,31,247,31,132,31,160,31,157,31,246,31,94,31,101,31,101,30,133,31,131,31,86,31,86,30,86,29,188,31,202,31,139,31,244,31,20,31,106,31,40,31,40,30,190,31,1,31,166,31,195,31,66,31,38,31,179,31,179,30,251,31,8,31,102,31,158,31,178,31,207,31,108,31,231,31,246,31,171,31,171,30,19,31,213,31,28,31,109,31,102,31,102,30,222,31,26,31,198,31,76,31,244,31,110,31,202,31,75,31,75,30,138,31,197,31,53,31,218,31,44,31,44,30,218,31,12,31,12,30,147,31,168,31,227,31,33,31,204,31,204,30,204,29,232,31,212,31,240,31,114,31,114,30,76,31,108,31,234,31,253,31,94,31,200,31,59,31,114,31,102,31,177,31,29,31,196,31,216,31,69,31,116,31,40,31,40,30,57,31,57,30,140,31,236,31,158,31,203,31,76,31,42,31,198,31,202,31,23,31,1,31,76,31,93,31,240,31,240,30,140,31,140,30,114,31,80,31,145,31,21,31,121,31,121,30,182,31,219,31,187,31,115,31,47,31,155,31,155,30,146,31,160,31,160,30,90,31,70,31,195,31,44,31,144,31,252,31,198,31,198,30,193,31,89,31,68,31,68,30,68,29,172,31,196,31,174,31,227,31,227,30,154,31,154,30,44,31,28,31,154,31,22,31,236,31,61,31,61,30,228,31,215,31,130,31,202,31,254,31,254,30,206,31,219,31,219,30,164,31,253,31,37,31,184,31,62,31,210,31,113,31,180,31,116,31,182,31,38,31,17,31,252,31,202,31,148,31,148,30,148,29,117,31,44,31,44,30,176,31,71,31,40,31,40,30,133,31,16,31,254,31,94,31,118,31,169,31,24,31,85,31,251,31,201,31,73,31,73,30,134,31,131,31,109,31,86,31,38,31,185,31,153,31,32,31,73,31,34,31,227,31,227,30,145,31,82,31,82,30,100,31,173,31,145,31,255,31,117,31,185,31,30,31,68,31,216,31,196,31,196,30,53,31,234,31,99,31,173,31,11,31,11,30,11,29,11,28,11,27,155,31,228,31,24,31,60,31,107,31,107,30,107,29,41,31,65,31,65,30,29,31,240,31,240,30,204,31,204,30,61,31,189,31,73,31,104,31,228,31,105,31,92,31,51,31,232,31,185,31,18,31,60,31,147,31,196,31,127,31,39,31,243,31,234,31,213,31,213,30,156,31,233,31,232,31,158,31,224,31,176,31,229,31,92,31,164,31,101,31,101,30,91,31,163,31,61,31,120,31,208,31,38,31,38,30,24,31,88,31,239,31,90,31,124,31,92,31,10,31,10,30,200,31,182,31,58,31,58,30,96,31,55,31,222,31,222,30,228,31,133,31,229,31,190,31,40,31,40,30,40,29,40,28,40,27,39,31,9,31,9,30,248,31,248,30,248,29,5,31,242,31,242,30,255,31,255,30,146,31,153,31,1,31,176,31,131,31,255,31,103,31,8,31,14,31,33,31,33,30,192,31,192,30,192,29,128,31,98,31,191,31,119,31,240,31,240,30,240,29,227,31,71,31,106,31,106,30,231,31,231,30,244,31,32,31,144,31,144,30,145,31,34,31,97,31,167,31,218,31,218,30,159,31,7,31,234,31,242,31,176,31,159,31,95,31,244,31,76,31,247,31,216,31,7,31,177,31,114,31,248,31,33,31,8,31,54,31,72,31,52,31,138,31,58,31,66,31,198,31,89,31,89,30,185,31,185,30,30,31,30,30,171,31,107,31,187,31,125,31);

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
