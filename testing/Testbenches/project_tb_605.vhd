-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_605 is
end project_tb_605;

architecture project_tb_arch_605 of project_tb_605 is
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

constant SCENARIO_LENGTH : integer := 202;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,179,0,255,0,117,0,0,0,0,0,52,0,129,0,8,0,194,0,221,0,149,0,170,0,254,0,195,0,220,0,186,0,40,0,141,0,4,0,0,0,41,0,199,0,137,0,201,0,124,0,138,0,0,0,88,0,191,0,116,0,201,0,174,0,6,0,32,0,0,0,0,0,113,0,235,0,172,0,154,0,7,0,16,0,160,0,83,0,115,0,0,0,0,0,117,0,213,0,245,0,108,0,52,0,244,0,40,0,32,0,26,0,247,0,142,0,75,0,163,0,110,0,0,0,0,0,89,0,0,0,0,0,92,0,53,0,46,0,9,0,141,0,176,0,117,0,195,0,10,0,0,0,0,0,147,0,90,0,199,0,164,0,51,0,214,0,229,0,57,0,230,0,163,0,11,0,201,0,253,0,0,0,0,0,89,0,138,0,216,0,35,0,0,0,230,0,174,0,220,0,91,0,0,0,120,0,220,0,0,0,83,0,0,0,255,0,103,0,0,0,111,0,199,0,178,0,0,0,45,0,206,0,0,0,248,0,64,0,197,0,185,0,191,0,191,0,25,0,228,0,129,0,164,0,0,0,27,0,122,0,55,0,46,0,61,0,189,0,0,0,74,0,20,0,249,0,81,0,72,0,187,0,255,0,0,0,98,0,219,0,0,0,26,0,0,0,18,0,99,0,0,0,166,0,31,0,0,0,13,0,210,0,87,0,148,0,63,0,89,0,241,0,32,0,129,0,0,0,173,0,149,0,60,0,0,0,0,0,110,0,165,0,81,0,0,0,0,0,210,0,94,0,28,0,127,0,219,0,98,0,155,0,20,0,0,0,143,0,0,0,65,0,122,0,0,0,168,0,0,0,10,0,134,0,188,0,16,0,5,0,153,0,171,0,203,0,236,0,198,0,29,0);
signal scenario_full  : scenario_type := (0,0,179,31,255,31,117,31,117,30,117,29,52,31,129,31,8,31,194,31,221,31,149,31,170,31,254,31,195,31,220,31,186,31,40,31,141,31,4,31,4,30,41,31,199,31,137,31,201,31,124,31,138,31,138,30,88,31,191,31,116,31,201,31,174,31,6,31,32,31,32,30,32,29,113,31,235,31,172,31,154,31,7,31,16,31,160,31,83,31,115,31,115,30,115,29,117,31,213,31,245,31,108,31,52,31,244,31,40,31,32,31,26,31,247,31,142,31,75,31,163,31,110,31,110,30,110,29,89,31,89,30,89,29,92,31,53,31,46,31,9,31,141,31,176,31,117,31,195,31,10,31,10,30,10,29,147,31,90,31,199,31,164,31,51,31,214,31,229,31,57,31,230,31,163,31,11,31,201,31,253,31,253,30,253,29,89,31,138,31,216,31,35,31,35,30,230,31,174,31,220,31,91,31,91,30,120,31,220,31,220,30,83,31,83,30,255,31,103,31,103,30,111,31,199,31,178,31,178,30,45,31,206,31,206,30,248,31,64,31,197,31,185,31,191,31,191,31,25,31,228,31,129,31,164,31,164,30,27,31,122,31,55,31,46,31,61,31,189,31,189,30,74,31,20,31,249,31,81,31,72,31,187,31,255,31,255,30,98,31,219,31,219,30,26,31,26,30,18,31,99,31,99,30,166,31,31,31,31,30,13,31,210,31,87,31,148,31,63,31,89,31,241,31,32,31,129,31,129,30,173,31,149,31,60,31,60,30,60,29,110,31,165,31,81,31,81,30,81,29,210,31,94,31,28,31,127,31,219,31,98,31,155,31,20,31,20,30,143,31,143,30,65,31,122,31,122,30,168,31,168,30,10,31,134,31,188,31,16,31,5,31,153,31,171,31,203,31,236,31,198,31,29,31);

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
