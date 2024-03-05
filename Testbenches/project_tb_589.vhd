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

constant SCENARIO_LENGTH : integer := 225;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (230,0,186,0,184,0,0,0,91,0,0,0,0,0,17,0,7,0,156,0,171,0,57,0,180,0,0,0,0,0,108,0,12,0,76,0,73,0,80,0,0,0,130,0,56,0,0,0,111,0,75,0,188,0,0,0,0,0,114,0,103,0,106,0,182,0,59,0,168,0,83,0,50,0,0,0,248,0,253,0,4,0,131,0,239,0,101,0,0,0,0,0,162,0,135,0,0,0,120,0,129,0,92,0,114,0,31,0,146,0,175,0,135,0,12,0,111,0,0,0,23,0,11,0,152,0,27,0,88,0,39,0,135,0,0,0,101,0,194,0,122,0,0,0,155,0,216,0,226,0,0,0,202,0,228,0,199,0,172,0,0,0,212,0,84,0,56,0,0,0,212,0,240,0,0,0,50,0,52,0,233,0,240,0,0,0,149,0,52,0,245,0,248,0,158,0,6,0,238,0,57,0,4,0,119,0,0,0,117,0,110,0,230,0,0,0,34,0,0,0,196,0,240,0,54,0,72,0,76,0,177,0,204,0,236,0,239,0,218,0,143,0,106,0,254,0,0,0,0,0,138,0,11,0,172,0,226,0,164,0,21,0,74,0,107,0,114,0,193,0,23,0,190,0,108,0,200,0,156,0,0,0,0,0,91,0,183,0,179,0,213,0,7,0,62,0,15,0,0,0,142,0,50,0,33,0,190,0,190,0,209,0,75,0,128,0,192,0,71,0,185,0,0,0,0,0,26,0,245,0,23,0,230,0,133,0,172,0,112,0,0,0,13,0,21,0,49,0,0,0,67,0,0,0,218,0,216,0,0,0,58,0,226,0,13,0,0,0,126,0,162,0,170,0,45,0,191,0,73,0,0,0,93,0,253,0,0,0,203,0,93,0,63,0,36,0,55,0,213,0,169,0,0,0,219,0,221,0,117,0,223,0,39,0,189,0,0,0,208,0,113,0,46,0,0,0,169,0,190,0,133,0,157,0,30,0,14,0,50,0,88,0,0,0,25,0,167,0,253,0);
signal scenario_full  : scenario_type := (230,31,186,31,184,31,184,30,91,31,91,30,91,29,17,31,7,31,156,31,171,31,57,31,180,31,180,30,180,29,108,31,12,31,76,31,73,31,80,31,80,30,130,31,56,31,56,30,111,31,75,31,188,31,188,30,188,29,114,31,103,31,106,31,182,31,59,31,168,31,83,31,50,31,50,30,248,31,253,31,4,31,131,31,239,31,101,31,101,30,101,29,162,31,135,31,135,30,120,31,129,31,92,31,114,31,31,31,146,31,175,31,135,31,12,31,111,31,111,30,23,31,11,31,152,31,27,31,88,31,39,31,135,31,135,30,101,31,194,31,122,31,122,30,155,31,216,31,226,31,226,30,202,31,228,31,199,31,172,31,172,30,212,31,84,31,56,31,56,30,212,31,240,31,240,30,50,31,52,31,233,31,240,31,240,30,149,31,52,31,245,31,248,31,158,31,6,31,238,31,57,31,4,31,119,31,119,30,117,31,110,31,230,31,230,30,34,31,34,30,196,31,240,31,54,31,72,31,76,31,177,31,204,31,236,31,239,31,218,31,143,31,106,31,254,31,254,30,254,29,138,31,11,31,172,31,226,31,164,31,21,31,74,31,107,31,114,31,193,31,23,31,190,31,108,31,200,31,156,31,156,30,156,29,91,31,183,31,179,31,213,31,7,31,62,31,15,31,15,30,142,31,50,31,33,31,190,31,190,31,209,31,75,31,128,31,192,31,71,31,185,31,185,30,185,29,26,31,245,31,23,31,230,31,133,31,172,31,112,31,112,30,13,31,21,31,49,31,49,30,67,31,67,30,218,31,216,31,216,30,58,31,226,31,13,31,13,30,126,31,162,31,170,31,45,31,191,31,73,31,73,30,93,31,253,31,253,30,203,31,93,31,63,31,36,31,55,31,213,31,169,31,169,30,219,31,221,31,117,31,223,31,39,31,189,31,189,30,208,31,113,31,46,31,46,30,169,31,190,31,133,31,157,31,30,31,14,31,50,31,88,31,88,30,25,31,167,31,253,31);

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
