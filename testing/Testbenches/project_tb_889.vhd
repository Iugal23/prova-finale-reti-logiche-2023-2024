-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_889 is
end project_tb_889;

architecture project_tb_arch_889 of project_tb_889 is
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

constant SCENARIO_LENGTH : integer := 353;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,215,0,114,0,82,0,203,0,0,0,162,0,214,0,34,0,221,0,133,0,89,0,0,0,35,0,108,0,112,0,44,0,75,0,67,0,179,0,124,0,139,0,66,0,35,0,207,0,0,0,0,0,200,0,0,0,218,0,209,0,23,0,252,0,62,0,89,0,64,0,177,0,187,0,82,0,0,0,155,0,82,0,244,0,79,0,116,0,36,0,193,0,225,0,0,0,34,0,47,0,65,0,125,0,243,0,152,0,178,0,240,0,33,0,28,0,224,0,135,0,0,0,38,0,96,0,181,0,0,0,209,0,37,0,72,0,120,0,232,0,0,0,81,0,37,0,0,0,46,0,251,0,216,0,169,0,127,0,116,0,0,0,135,0,211,0,82,0,0,0,3,0,0,0,0,0,207,0,251,0,46,0,187,0,92,0,88,0,59,0,25,0,65,0,196,0,16,0,178,0,57,0,232,0,252,0,0,0,114,0,46,0,115,0,29,0,91,0,80,0,150,0,0,0,0,0,170,0,179,0,92,0,168,0,23,0,12,0,254,0,0,0,0,0,208,0,148,0,109,0,141,0,245,0,27,0,0,0,0,0,165,0,254,0,12,0,64,0,0,0,85,0,0,0,0,0,168,0,104,0,170,0,0,0,76,0,17,0,0,0,196,0,221,0,119,0,74,0,56,0,131,0,185,0,233,0,44,0,87,0,139,0,242,0,245,0,142,0,127,0,51,0,0,0,97,0,108,0,89,0,223,0,189,0,5,0,0,0,10,0,227,0,114,0,207,0,0,0,170,0,0,0,213,0,255,0,94,0,169,0,195,0,81,0,216,0,0,0,0,0,61,0,56,0,198,0,0,0,30,0,160,0,181,0,124,0,224,0,208,0,253,0,196,0,0,0,0,0,0,0,96,0,120,0,0,0,77,0,47,0,0,0,83,0,23,0,106,0,15,0,125,0,94,0,0,0,104,0,0,0,0,0,0,0,0,0,59,0,68,0,76,0,111,0,192,0,39,0,146,0,0,0,0,0,0,0,52,0,0,0,189,0,32,0,0,0,200,0,78,0,0,0,214,0,243,0,211,0,26,0,21,0,0,0,81,0,154,0,30,0,62,0,146,0,218,0,213,0,216,0,154,0,150,0,28,0,0,0,170,0,98,0,15,0,188,0,114,0,0,0,150,0,0,0,0,0,151,0,210,0,4,0,118,0,139,0,0,0,0,0,29,0,99,0,0,0,185,0,110,0,126,0,250,0,0,0,90,0,0,0,66,0,244,0,112,0,0,0,0,0,95,0,121,0,55,0,29,0,239,0,105,0,0,0,16,0,52,0,0,0,251,0,45,0,109,0,215,0,29,0,0,0,133,0,69,0,208,0,246,0,152,0,0,0,46,0,135,0,228,0,199,0,130,0,0,0,47,0,118,0,163,0,0,0,153,0,176,0,168,0,44,0,173,0,0,0,31,0,219,0,202,0,211,0,234,0,185,0,32,0,0,0,67,0,250,0,0,0,193,0,180,0,0,0,38,0,12,0,0,0,215,0,0,0,0,0,255,0,145,0,247,0,119,0,160,0,63,0,233,0,0,0,162,0);
signal scenario_full  : scenario_type := (0,0,215,31,114,31,82,31,203,31,203,30,162,31,214,31,34,31,221,31,133,31,89,31,89,30,35,31,108,31,112,31,44,31,75,31,67,31,179,31,124,31,139,31,66,31,35,31,207,31,207,30,207,29,200,31,200,30,218,31,209,31,23,31,252,31,62,31,89,31,64,31,177,31,187,31,82,31,82,30,155,31,82,31,244,31,79,31,116,31,36,31,193,31,225,31,225,30,34,31,47,31,65,31,125,31,243,31,152,31,178,31,240,31,33,31,28,31,224,31,135,31,135,30,38,31,96,31,181,31,181,30,209,31,37,31,72,31,120,31,232,31,232,30,81,31,37,31,37,30,46,31,251,31,216,31,169,31,127,31,116,31,116,30,135,31,211,31,82,31,82,30,3,31,3,30,3,29,207,31,251,31,46,31,187,31,92,31,88,31,59,31,25,31,65,31,196,31,16,31,178,31,57,31,232,31,252,31,252,30,114,31,46,31,115,31,29,31,91,31,80,31,150,31,150,30,150,29,170,31,179,31,92,31,168,31,23,31,12,31,254,31,254,30,254,29,208,31,148,31,109,31,141,31,245,31,27,31,27,30,27,29,165,31,254,31,12,31,64,31,64,30,85,31,85,30,85,29,168,31,104,31,170,31,170,30,76,31,17,31,17,30,196,31,221,31,119,31,74,31,56,31,131,31,185,31,233,31,44,31,87,31,139,31,242,31,245,31,142,31,127,31,51,31,51,30,97,31,108,31,89,31,223,31,189,31,5,31,5,30,10,31,227,31,114,31,207,31,207,30,170,31,170,30,213,31,255,31,94,31,169,31,195,31,81,31,216,31,216,30,216,29,61,31,56,31,198,31,198,30,30,31,160,31,181,31,124,31,224,31,208,31,253,31,196,31,196,30,196,29,196,28,96,31,120,31,120,30,77,31,47,31,47,30,83,31,23,31,106,31,15,31,125,31,94,31,94,30,104,31,104,30,104,29,104,28,104,27,59,31,68,31,76,31,111,31,192,31,39,31,146,31,146,30,146,29,146,28,52,31,52,30,189,31,32,31,32,30,200,31,78,31,78,30,214,31,243,31,211,31,26,31,21,31,21,30,81,31,154,31,30,31,62,31,146,31,218,31,213,31,216,31,154,31,150,31,28,31,28,30,170,31,98,31,15,31,188,31,114,31,114,30,150,31,150,30,150,29,151,31,210,31,4,31,118,31,139,31,139,30,139,29,29,31,99,31,99,30,185,31,110,31,126,31,250,31,250,30,90,31,90,30,66,31,244,31,112,31,112,30,112,29,95,31,121,31,55,31,29,31,239,31,105,31,105,30,16,31,52,31,52,30,251,31,45,31,109,31,215,31,29,31,29,30,133,31,69,31,208,31,246,31,152,31,152,30,46,31,135,31,228,31,199,31,130,31,130,30,47,31,118,31,163,31,163,30,153,31,176,31,168,31,44,31,173,31,173,30,31,31,219,31,202,31,211,31,234,31,185,31,32,31,32,30,67,31,250,31,250,30,193,31,180,31,180,30,38,31,12,31,12,30,215,31,215,30,215,29,255,31,145,31,247,31,119,31,160,31,63,31,233,31,233,30,162,31);

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
