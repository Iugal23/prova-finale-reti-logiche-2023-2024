-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_422 is
end project_tb_422;

architecture project_tb_arch_422 of project_tb_422 is
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

constant SCENARIO_LENGTH : integer := 254;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,11,0,0,0,246,0,0,0,220,0,121,0,90,0,82,0,233,0,193,0,173,0,174,0,211,0,0,0,44,0,0,0,45,0,168,0,53,0,172,0,85,0,29,0,156,0,49,0,203,0,0,0,119,0,89,0,64,0,133,0,253,0,154,0,53,0,161,0,136,0,53,0,53,0,254,0,159,0,0,0,181,0,107,0,63,0,0,0,187,0,132,0,245,0,175,0,83,0,0,0,60,0,193,0,0,0,0,0,250,0,184,0,163,0,15,0,32,0,220,0,115,0,54,0,0,0,0,0,99,0,173,0,44,0,236,0,0,0,103,0,0,0,231,0,100,0,0,0,67,0,59,0,0,0,23,0,199,0,165,0,251,0,44,0,18,0,65,0,71,0,61,0,67,0,7,0,87,0,87,0,148,0,13,0,0,0,46,0,57,0,0,0,226,0,255,0,0,0,82,0,0,0,181,0,106,0,176,0,49,0,120,0,132,0,124,0,178,0,139,0,75,0,0,0,179,0,140,0,0,0,203,0,187,0,164,0,243,0,229,0,20,0,245,0,0,0,36,0,135,0,25,0,53,0,240,0,86,0,41,0,0,0,53,0,228,0,169,0,0,0,190,0,153,0,160,0,116,0,83,0,106,0,30,0,8,0,197,0,17,0,199,0,153,0,234,0,148,0,96,0,206,0,63,0,95,0,0,0,189,0,70,0,240,0,0,0,205,0,153,0,12,0,181,0,62,0,36,0,159,0,223,0,234,0,199,0,211,0,242,0,209,0,77,0,0,0,0,0,201,0,40,0,108,0,101,0,152,0,184,0,47,0,136,0,181,0,79,0,253,0,0,0,70,0,129,0,49,0,62,0,115,0,0,0,56,0,0,0,0,0,83,0,16,0,7,0,41,0,255,0,0,0,155,0,0,0,25,0,171,0,246,0,198,0,51,0,187,0,178,0,162,0,200,0,213,0,170,0,211,0,111,0,17,0,144,0,0,0,33,0,77,0,102,0,112,0,77,0,79,0,44,0,0,0,109,0,248,0,4,0,0,0,210,0,14,0,16,0,249,0,43,0,0,0,205,0,254,0,255,0,188,0,15,0,113,0,100,0,194,0,73,0,213,0,237,0,43,0,175,0,2,0,178,0,234,0);
signal scenario_full  : scenario_type := (0,0,11,31,11,30,246,31,246,30,220,31,121,31,90,31,82,31,233,31,193,31,173,31,174,31,211,31,211,30,44,31,44,30,45,31,168,31,53,31,172,31,85,31,29,31,156,31,49,31,203,31,203,30,119,31,89,31,64,31,133,31,253,31,154,31,53,31,161,31,136,31,53,31,53,31,254,31,159,31,159,30,181,31,107,31,63,31,63,30,187,31,132,31,245,31,175,31,83,31,83,30,60,31,193,31,193,30,193,29,250,31,184,31,163,31,15,31,32,31,220,31,115,31,54,31,54,30,54,29,99,31,173,31,44,31,236,31,236,30,103,31,103,30,231,31,100,31,100,30,67,31,59,31,59,30,23,31,199,31,165,31,251,31,44,31,18,31,65,31,71,31,61,31,67,31,7,31,87,31,87,31,148,31,13,31,13,30,46,31,57,31,57,30,226,31,255,31,255,30,82,31,82,30,181,31,106,31,176,31,49,31,120,31,132,31,124,31,178,31,139,31,75,31,75,30,179,31,140,31,140,30,203,31,187,31,164,31,243,31,229,31,20,31,245,31,245,30,36,31,135,31,25,31,53,31,240,31,86,31,41,31,41,30,53,31,228,31,169,31,169,30,190,31,153,31,160,31,116,31,83,31,106,31,30,31,8,31,197,31,17,31,199,31,153,31,234,31,148,31,96,31,206,31,63,31,95,31,95,30,189,31,70,31,240,31,240,30,205,31,153,31,12,31,181,31,62,31,36,31,159,31,223,31,234,31,199,31,211,31,242,31,209,31,77,31,77,30,77,29,201,31,40,31,108,31,101,31,152,31,184,31,47,31,136,31,181,31,79,31,253,31,253,30,70,31,129,31,49,31,62,31,115,31,115,30,56,31,56,30,56,29,83,31,16,31,7,31,41,31,255,31,255,30,155,31,155,30,25,31,171,31,246,31,198,31,51,31,187,31,178,31,162,31,200,31,213,31,170,31,211,31,111,31,17,31,144,31,144,30,33,31,77,31,102,31,112,31,77,31,79,31,44,31,44,30,109,31,248,31,4,31,4,30,210,31,14,31,16,31,249,31,43,31,43,30,205,31,254,31,255,31,188,31,15,31,113,31,100,31,194,31,73,31,213,31,237,31,43,31,175,31,2,31,178,31,234,31);

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
