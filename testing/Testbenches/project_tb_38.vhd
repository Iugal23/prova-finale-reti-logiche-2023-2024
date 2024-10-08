-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_38 is
end project_tb_38;

architecture project_tb_arch_38 of project_tb_38 is
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

constant SCENARIO_LENGTH : integer := 531;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (69,0,12,0,110,0,59,0,103,0,169,0,100,0,220,0,89,0,133,0,56,0,126,0,184,0,178,0,194,0,0,0,86,0,50,0,32,0,0,0,96,0,159,0,87,0,1,0,217,0,0,0,71,0,66,0,0,0,7,0,167,0,170,0,95,0,196,0,163,0,82,0,226,0,229,0,221,0,93,0,48,0,110,0,23,0,0,0,0,0,204,0,0,0,229,0,212,0,77,0,0,0,0,0,0,0,225,0,45,0,189,0,46,0,169,0,57,0,0,0,0,0,86,0,39,0,0,0,70,0,173,0,224,0,0,0,0,0,24,0,183,0,72,0,0,0,0,0,176,0,107,0,44,0,171,0,178,0,11,0,0,0,0,0,221,0,54,0,221,0,175,0,76,0,23,0,0,0,50,0,13,0,57,0,0,0,190,0,133,0,116,0,108,0,105,0,56,0,113,0,41,0,26,0,97,0,132,0,0,0,75,0,124,0,247,0,151,0,58,0,237,0,144,0,151,0,214,0,135,0,0,0,0,0,246,0,98,0,199,0,39,0,134,0,189,0,217,0,77,0,8,0,0,0,97,0,232,0,207,0,186,0,4,0,0,0,0,0,198,0,18,0,140,0,128,0,142,0,252,0,130,0,163,0,81,0,232,0,94,0,0,0,162,0,93,0,190,0,0,0,87,0,99,0,248,0,107,0,37,0,215,0,146,0,0,0,66,0,0,0,0,0,183,0,137,0,190,0,42,0,185,0,137,0,182,0,223,0,0,0,23,0,219,0,0,0,67,0,139,0,0,0,131,0,108,0,45,0,194,0,126,0,0,0,141,0,0,0,30,0,79,0,139,0,173,0,119,0,67,0,182,0,181,0,55,0,161,0,67,0,65,0,53,0,234,0,251,0,148,0,52,0,15,0,192,0,132,0,0,0,250,0,0,0,198,0,0,0,0,0,174,0,52,0,150,0,156,0,193,0,70,0,29,0,56,0,113,0,36,0,222,0,129,0,228,0,213,0,251,0,222,0,2,0,253,0,190,0,19,0,45,0,14,0,0,0,232,0,23,0,165,0,181,0,0,0,0,0,79,0,63,0,50,0,115,0,0,0,13,0,213,0,254,0,191,0,160,0,64,0,0,0,0,0,89,0,19,0,43,0,229,0,0,0,47,0,59,0,0,0,249,0,239,0,171,0,229,0,0,0,0,0,0,0,192,0,22,0,220,0,6,0,157,0,6,0,245,0,0,0,196,0,45,0,236,0,90,0,207,0,6,0,0,0,216,0,80,0,104,0,0,0,0,0,115,0,199,0,197,0,98,0,0,0,176,0,202,0,24,0,201,0,15,0,152,0,231,0,85,0,247,0,0,0,65,0,0,0,52,0,61,0,187,0,176,0,147,0,60,0,157,0,0,0,83,0,69,0,121,0,131,0,75,0,106,0,74,0,0,0,87,0,0,0,49,0,0,0,131,0,89,0,104,0,109,0,12,0,188,0,42,0,162,0,56,0,2,0,221,0,245,0,215,0,100,0,158,0,50,0,232,0,87,0,0,0,170,0,43,0,56,0,127,0,63,0,0,0,47,0,0,0,110,0,155,0,140,0,236,0,53,0,0,0,51,0,0,0,0,0,83,0,178,0,57,0,253,0,182,0,15,0,195,0,34,0,239,0,83,0,62,0,203,0,255,0,242,0,218,0,113,0,96,0,198,0,181,0,0,0,104,0,107,0,78,0,27,0,8,0,188,0,21,0,80,0,100,0,0,0,0,0,30,0,36,0,167,0,98,0,85,0,90,0,79,0,254,0,0,0,142,0,99,0,142,0,56,0,127,0,178,0,45,0,0,0,12,0,218,0,0,0,214,0,93,0,216,0,0,0,205,0,78,0,189,0,218,0,0,0,219,0,25,0,207,0,0,0,219,0,3,0,0,0,219,0,0,0,72,0,104,0,0,0,0,0,11,0,0,0,206,0,79,0,197,0,31,0,244,0,70,0,141,0,33,0,140,0,0,0,0,0,182,0,85,0,38,0,228,0,74,0,249,0,15,0,111,0,63,0,102,0,2,0,144,0,157,0,170,0,185,0,0,0,30,0,135,0,66,0,0,0,119,0,85,0,0,0,44,0,0,0,0,0,29,0,206,0,153,0,37,0,200,0,17,0,169,0,242,0,0,0,239,0,250,0,0,0,0,0,96,0,46,0,17,0,0,0,146,0,159,0,222,0,0,0,209,0,118,0,132,0,0,0,49,0,141,0,234,0,25,0,132,0,35,0,65,0,32,0,0,0,107,0,192,0,0,0,0,0,59,0,122,0,62,0,6,0,19,0,151,0,168,0,0,0,28,0,191,0,93,0,214,0,214,0,101,0,133,0,189,0,132,0,28,0,34,0,179,0,231,0);
signal scenario_full  : scenario_type := (69,31,12,31,110,31,59,31,103,31,169,31,100,31,220,31,89,31,133,31,56,31,126,31,184,31,178,31,194,31,194,30,86,31,50,31,32,31,32,30,96,31,159,31,87,31,1,31,217,31,217,30,71,31,66,31,66,30,7,31,167,31,170,31,95,31,196,31,163,31,82,31,226,31,229,31,221,31,93,31,48,31,110,31,23,31,23,30,23,29,204,31,204,30,229,31,212,31,77,31,77,30,77,29,77,28,225,31,45,31,189,31,46,31,169,31,57,31,57,30,57,29,86,31,39,31,39,30,70,31,173,31,224,31,224,30,224,29,24,31,183,31,72,31,72,30,72,29,176,31,107,31,44,31,171,31,178,31,11,31,11,30,11,29,221,31,54,31,221,31,175,31,76,31,23,31,23,30,50,31,13,31,57,31,57,30,190,31,133,31,116,31,108,31,105,31,56,31,113,31,41,31,26,31,97,31,132,31,132,30,75,31,124,31,247,31,151,31,58,31,237,31,144,31,151,31,214,31,135,31,135,30,135,29,246,31,98,31,199,31,39,31,134,31,189,31,217,31,77,31,8,31,8,30,97,31,232,31,207,31,186,31,4,31,4,30,4,29,198,31,18,31,140,31,128,31,142,31,252,31,130,31,163,31,81,31,232,31,94,31,94,30,162,31,93,31,190,31,190,30,87,31,99,31,248,31,107,31,37,31,215,31,146,31,146,30,66,31,66,30,66,29,183,31,137,31,190,31,42,31,185,31,137,31,182,31,223,31,223,30,23,31,219,31,219,30,67,31,139,31,139,30,131,31,108,31,45,31,194,31,126,31,126,30,141,31,141,30,30,31,79,31,139,31,173,31,119,31,67,31,182,31,181,31,55,31,161,31,67,31,65,31,53,31,234,31,251,31,148,31,52,31,15,31,192,31,132,31,132,30,250,31,250,30,198,31,198,30,198,29,174,31,52,31,150,31,156,31,193,31,70,31,29,31,56,31,113,31,36,31,222,31,129,31,228,31,213,31,251,31,222,31,2,31,253,31,190,31,19,31,45,31,14,31,14,30,232,31,23,31,165,31,181,31,181,30,181,29,79,31,63,31,50,31,115,31,115,30,13,31,213,31,254,31,191,31,160,31,64,31,64,30,64,29,89,31,19,31,43,31,229,31,229,30,47,31,59,31,59,30,249,31,239,31,171,31,229,31,229,30,229,29,229,28,192,31,22,31,220,31,6,31,157,31,6,31,245,31,245,30,196,31,45,31,236,31,90,31,207,31,6,31,6,30,216,31,80,31,104,31,104,30,104,29,115,31,199,31,197,31,98,31,98,30,176,31,202,31,24,31,201,31,15,31,152,31,231,31,85,31,247,31,247,30,65,31,65,30,52,31,61,31,187,31,176,31,147,31,60,31,157,31,157,30,83,31,69,31,121,31,131,31,75,31,106,31,74,31,74,30,87,31,87,30,49,31,49,30,131,31,89,31,104,31,109,31,12,31,188,31,42,31,162,31,56,31,2,31,221,31,245,31,215,31,100,31,158,31,50,31,232,31,87,31,87,30,170,31,43,31,56,31,127,31,63,31,63,30,47,31,47,30,110,31,155,31,140,31,236,31,53,31,53,30,51,31,51,30,51,29,83,31,178,31,57,31,253,31,182,31,15,31,195,31,34,31,239,31,83,31,62,31,203,31,255,31,242,31,218,31,113,31,96,31,198,31,181,31,181,30,104,31,107,31,78,31,27,31,8,31,188,31,21,31,80,31,100,31,100,30,100,29,30,31,36,31,167,31,98,31,85,31,90,31,79,31,254,31,254,30,142,31,99,31,142,31,56,31,127,31,178,31,45,31,45,30,12,31,218,31,218,30,214,31,93,31,216,31,216,30,205,31,78,31,189,31,218,31,218,30,219,31,25,31,207,31,207,30,219,31,3,31,3,30,219,31,219,30,72,31,104,31,104,30,104,29,11,31,11,30,206,31,79,31,197,31,31,31,244,31,70,31,141,31,33,31,140,31,140,30,140,29,182,31,85,31,38,31,228,31,74,31,249,31,15,31,111,31,63,31,102,31,2,31,144,31,157,31,170,31,185,31,185,30,30,31,135,31,66,31,66,30,119,31,85,31,85,30,44,31,44,30,44,29,29,31,206,31,153,31,37,31,200,31,17,31,169,31,242,31,242,30,239,31,250,31,250,30,250,29,96,31,46,31,17,31,17,30,146,31,159,31,222,31,222,30,209,31,118,31,132,31,132,30,49,31,141,31,234,31,25,31,132,31,35,31,65,31,32,31,32,30,107,31,192,31,192,30,192,29,59,31,122,31,62,31,6,31,19,31,151,31,168,31,168,30,28,31,191,31,93,31,214,31,214,31,101,31,133,31,189,31,132,31,28,31,34,31,179,31,231,31);

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
