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

constant SCENARIO_LENGTH : integer := 239;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (94,0,38,0,55,0,45,0,0,0,164,0,193,0,0,0,0,0,0,0,218,0,211,0,114,0,0,0,0,0,0,0,0,0,118,0,85,0,236,0,236,0,189,0,171,0,17,0,190,0,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,202,0,22,0,0,0,0,0,220,0,234,0,198,0,84,0,88,0,134,0,0,0,253,0,218,0,27,0,141,0,0,0,0,0,0,0,0,0,29,0,219,0,179,0,0,0,89,0,188,0,148,0,182,0,0,0,0,0,60,0,18,0,33,0,174,0,239,0,0,0,108,0,32,0,249,0,155,0,181,0,10,0,0,0,38,0,220,0,22,0,0,0,0,0,136,0,0,0,0,0,0,0,0,0,63,0,0,0,0,0,189,0,0,0,205,0,238,0,255,0,0,0,171,0,251,0,0,0,176,0,162,0,130,0,0,0,173,0,245,0,140,0,61,0,139,0,237,0,132,0,25,0,112,0,182,0,67,0,0,0,166,0,131,0,25,0,50,0,232,0,21,0,0,0,179,0,59,0,120,0,0,0,131,0,198,0,220,0,40,0,199,0,233,0,113,0,206,0,37,0,219,0,0,0,0,0,23,0,14,0,236,0,54,0,41,0,159,0,77,0,161,0,133,0,165,0,169,0,103,0,68,0,243,0,227,0,7,0,64,0,29,0,117,0,23,0,121,0,9,0,0,0,0,0,86,0,227,0,163,0,0,0,59,0,169,0,63,0,235,0,20,0,117,0,65,0,0,0,180,0,107,0,250,0,224,0,186,0,0,0,73,0,0,0,254,0,82,0,135,0,0,0,79,0,187,0,84,0,68,0,191,0,31,0,158,0,180,0,184,0,0,0,0,0,86,0,227,0,210,0,165,0,104,0,103,0,218,0,49,0,66,0,99,0,115,0,125,0,0,0,31,0,0,0,0,0,0,0,13,0,125,0,191,0,0,0,185,0,8,0,1,0,0,0,0,0,183,0,32,0,106,0,180,0,24,0,0,0,243,0,152,0,255,0,111,0,186,0,222,0,226,0,201,0,64,0,0,0,242,0,136,0);
signal scenario_full  : scenario_type := (94,31,38,31,55,31,45,31,45,30,164,31,193,31,193,30,193,29,193,28,218,31,211,31,114,31,114,30,114,29,114,28,114,27,118,31,85,31,236,31,236,31,189,31,171,31,17,31,190,31,22,31,22,30,22,29,22,28,22,27,22,26,22,25,22,24,202,31,22,31,22,30,22,29,220,31,234,31,198,31,84,31,88,31,134,31,134,30,253,31,218,31,27,31,141,31,141,30,141,29,141,28,141,27,29,31,219,31,179,31,179,30,89,31,188,31,148,31,182,31,182,30,182,29,60,31,18,31,33,31,174,31,239,31,239,30,108,31,32,31,249,31,155,31,181,31,10,31,10,30,38,31,220,31,22,31,22,30,22,29,136,31,136,30,136,29,136,28,136,27,63,31,63,30,63,29,189,31,189,30,205,31,238,31,255,31,255,30,171,31,251,31,251,30,176,31,162,31,130,31,130,30,173,31,245,31,140,31,61,31,139,31,237,31,132,31,25,31,112,31,182,31,67,31,67,30,166,31,131,31,25,31,50,31,232,31,21,31,21,30,179,31,59,31,120,31,120,30,131,31,198,31,220,31,40,31,199,31,233,31,113,31,206,31,37,31,219,31,219,30,219,29,23,31,14,31,236,31,54,31,41,31,159,31,77,31,161,31,133,31,165,31,169,31,103,31,68,31,243,31,227,31,7,31,64,31,29,31,117,31,23,31,121,31,9,31,9,30,9,29,86,31,227,31,163,31,163,30,59,31,169,31,63,31,235,31,20,31,117,31,65,31,65,30,180,31,107,31,250,31,224,31,186,31,186,30,73,31,73,30,254,31,82,31,135,31,135,30,79,31,187,31,84,31,68,31,191,31,31,31,158,31,180,31,184,31,184,30,184,29,86,31,227,31,210,31,165,31,104,31,103,31,218,31,49,31,66,31,99,31,115,31,125,31,125,30,31,31,31,30,31,29,31,28,13,31,125,31,191,31,191,30,185,31,8,31,1,31,1,30,1,29,183,31,32,31,106,31,180,31,24,31,24,30,243,31,152,31,255,31,111,31,186,31,222,31,226,31,201,31,64,31,64,30,242,31,136,31);

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
