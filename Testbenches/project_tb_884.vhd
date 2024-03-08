-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_884 is
end project_tb_884;

architecture project_tb_arch_884 of project_tb_884 is
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

constant SCENARIO_LENGTH : integer := 187;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (72,0,238,0,130,0,117,0,111,0,123,0,211,0,94,0,0,0,25,0,220,0,3,0,95,0,232,0,220,0,53,0,127,0,236,0,148,0,0,0,143,0,88,0,220,0,228,0,90,0,43,0,115,0,148,0,58,0,192,0,12,0,149,0,54,0,120,0,234,0,34,0,11,0,188,0,0,0,37,0,82,0,77,0,126,0,223,0,192,0,90,0,0,0,0,0,202,0,73,0,51,0,0,0,101,0,88,0,241,0,183,0,247,0,0,0,0,0,56,0,0,0,190,0,1,0,0,0,200,0,244,0,153,0,26,0,25,0,0,0,0,0,198,0,248,0,0,0,39,0,0,0,92,0,185,0,0,0,241,0,199,0,167,0,226,0,83,0,119,0,180,0,231,0,235,0,242,0,0,0,0,0,69,0,191,0,136,0,226,0,143,0,78,0,179,0,150,0,11,0,221,0,209,0,236,0,128,0,0,0,0,0,40,0,166,0,124,0,0,0,0,0,190,0,91,0,196,0,191,0,132,0,238,0,135,0,92,0,143,0,0,0,73,0,0,0,65,0,75,0,182,0,96,0,190,0,247,0,95,0,240,0,50,0,0,0,3,0,156,0,160,0,96,0,0,0,179,0,27,0,194,0,9,0,0,0,63,0,232,0,215,0,51,0,0,0,72,0,58,0,29,0,121,0,0,0,247,0,222,0,13,0,60,0,102,0,112,0,230,0,160,0,0,0,173,0,54,0,0,0,141,0,0,0,89,0,184,0,26,0,227,0,0,0,242,0,0,0,4,0,0,0,84,0,0,0,0,0,0,0,44,0,168,0,236,0,165,0,44,0,176,0,0,0);
signal scenario_full  : scenario_type := (72,31,238,31,130,31,117,31,111,31,123,31,211,31,94,31,94,30,25,31,220,31,3,31,95,31,232,31,220,31,53,31,127,31,236,31,148,31,148,30,143,31,88,31,220,31,228,31,90,31,43,31,115,31,148,31,58,31,192,31,12,31,149,31,54,31,120,31,234,31,34,31,11,31,188,31,188,30,37,31,82,31,77,31,126,31,223,31,192,31,90,31,90,30,90,29,202,31,73,31,51,31,51,30,101,31,88,31,241,31,183,31,247,31,247,30,247,29,56,31,56,30,190,31,1,31,1,30,200,31,244,31,153,31,26,31,25,31,25,30,25,29,198,31,248,31,248,30,39,31,39,30,92,31,185,31,185,30,241,31,199,31,167,31,226,31,83,31,119,31,180,31,231,31,235,31,242,31,242,30,242,29,69,31,191,31,136,31,226,31,143,31,78,31,179,31,150,31,11,31,221,31,209,31,236,31,128,31,128,30,128,29,40,31,166,31,124,31,124,30,124,29,190,31,91,31,196,31,191,31,132,31,238,31,135,31,92,31,143,31,143,30,73,31,73,30,65,31,75,31,182,31,96,31,190,31,247,31,95,31,240,31,50,31,50,30,3,31,156,31,160,31,96,31,96,30,179,31,27,31,194,31,9,31,9,30,63,31,232,31,215,31,51,31,51,30,72,31,58,31,29,31,121,31,121,30,247,31,222,31,13,31,60,31,102,31,112,31,230,31,160,31,160,30,173,31,54,31,54,30,141,31,141,30,89,31,184,31,26,31,227,31,227,30,242,31,242,30,4,31,4,30,84,31,84,30,84,29,84,28,44,31,168,31,236,31,165,31,44,31,176,31,176,30);

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
