-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_584 is
end project_tb_584;

architecture project_tb_arch_584 of project_tb_584 is
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

constant SCENARIO_LENGTH : integer := 245;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (51,0,185,0,96,0,0,0,28,0,112,0,154,0,34,0,189,0,0,0,242,0,231,0,0,0,0,0,46,0,205,0,0,0,66,0,151,0,77,0,136,0,159,0,109,0,139,0,236,0,0,0,0,0,190,0,101,0,28,0,186,0,180,0,97,0,254,0,100,0,232,0,0,0,221,0,77,0,240,0,163,0,0,0,0,0,148,0,97,0,102,0,90,0,61,0,217,0,87,0,62,0,236,0,145,0,245,0,0,0,189,0,253,0,90,0,0,0,167,0,211,0,0,0,28,0,131,0,244,0,172,0,240,0,98,0,0,0,0,0,182,0,81,0,85,0,190,0,0,0,25,0,84,0,142,0,128,0,166,0,213,0,67,0,21,0,0,0,175,0,59,0,0,0,241,0,167,0,0,0,107,0,0,0,160,0,106,0,187,0,0,0,211,0,224,0,0,0,62,0,206,0,96,0,38,0,109,0,0,0,51,0,171,0,161,0,67,0,236,0,0,0,171,0,0,0,176,0,219,0,158,0,115,0,65,0,126,0,0,0,59,0,182,0,146,0,0,0,125,0,0,0,172,0,128,0,152,0,189,0,224,0,201,0,0,0,0,0,68,0,237,0,181,0,30,0,221,0,199,0,113,0,124,0,226,0,39,0,129,0,234,0,235,0,0,0,250,0,162,0,0,0,158,0,66,0,1,0,241,0,112,0,131,0,125,0,100,0,161,0,172,0,24,0,69,0,31,0,215,0,84,0,31,0,17,0,141,0,125,0,79,0,213,0,178,0,224,0,38,0,125,0,0,0,0,0,78,0,0,0,53,0,127,0,50,0,97,0,0,0,214,0,23,0,40,0,121,0,135,0,84,0,207,0,0,0,162,0,125,0,2,0,0,0,115,0,10,0,0,0,0,0,87,0,94,0,158,0,28,0,247,0,105,0,197,0,29,0,230,0,45,0,160,0,58,0,207,0,71,0,246,0,49,0,184,0,73,0,102,0,222,0,94,0,195,0,218,0,8,0,247,0,115,0,33,0,227,0,216,0,129,0,230,0,0,0,76,0,157,0,0,0,94,0,21,0,176,0,0,0,176,0,0,0,124,0,0,0,201,0);
signal scenario_full  : scenario_type := (51,31,185,31,96,31,96,30,28,31,112,31,154,31,34,31,189,31,189,30,242,31,231,31,231,30,231,29,46,31,205,31,205,30,66,31,151,31,77,31,136,31,159,31,109,31,139,31,236,31,236,30,236,29,190,31,101,31,28,31,186,31,180,31,97,31,254,31,100,31,232,31,232,30,221,31,77,31,240,31,163,31,163,30,163,29,148,31,97,31,102,31,90,31,61,31,217,31,87,31,62,31,236,31,145,31,245,31,245,30,189,31,253,31,90,31,90,30,167,31,211,31,211,30,28,31,131,31,244,31,172,31,240,31,98,31,98,30,98,29,182,31,81,31,85,31,190,31,190,30,25,31,84,31,142,31,128,31,166,31,213,31,67,31,21,31,21,30,175,31,59,31,59,30,241,31,167,31,167,30,107,31,107,30,160,31,106,31,187,31,187,30,211,31,224,31,224,30,62,31,206,31,96,31,38,31,109,31,109,30,51,31,171,31,161,31,67,31,236,31,236,30,171,31,171,30,176,31,219,31,158,31,115,31,65,31,126,31,126,30,59,31,182,31,146,31,146,30,125,31,125,30,172,31,128,31,152,31,189,31,224,31,201,31,201,30,201,29,68,31,237,31,181,31,30,31,221,31,199,31,113,31,124,31,226,31,39,31,129,31,234,31,235,31,235,30,250,31,162,31,162,30,158,31,66,31,1,31,241,31,112,31,131,31,125,31,100,31,161,31,172,31,24,31,69,31,31,31,215,31,84,31,31,31,17,31,141,31,125,31,79,31,213,31,178,31,224,31,38,31,125,31,125,30,125,29,78,31,78,30,53,31,127,31,50,31,97,31,97,30,214,31,23,31,40,31,121,31,135,31,84,31,207,31,207,30,162,31,125,31,2,31,2,30,115,31,10,31,10,30,10,29,87,31,94,31,158,31,28,31,247,31,105,31,197,31,29,31,230,31,45,31,160,31,58,31,207,31,71,31,246,31,49,31,184,31,73,31,102,31,222,31,94,31,195,31,218,31,8,31,247,31,115,31,33,31,227,31,216,31,129,31,230,31,230,30,76,31,157,31,157,30,94,31,21,31,176,31,176,30,176,31,176,30,124,31,124,30,201,31);

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
